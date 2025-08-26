#!/bin/bash
set -euo pipefail

# Run as normal user; use sudo for privileged operations when needed.
# Resolve script directory and pkglist paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/packages_required"
PACMAN_PKGFILE="$PKG_DIR/explicit-pacman.txt"
AUR_PKGFILE="$PKG_DIR/explicit-aur.txt"

if [[ ! -f "$PACMAN_PKGFILE" || ! -f "$AUR_PKGFILE" ]]; then
    echo "Error: expected package files not found in $PKG_DIR"
    echo "Ensure $PACMAN_PKGFILE and $AUR_PKGFILE exist."
    exit 1
fi

# Ensure not running as root because building AUR packages must be done as an unprivileged user
if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root. Please run it as your normal user. Exiting."
    exit 1
fi

echo "This script will update the system, install base packages, install yay (AUR helper) if missing, and then install packages from selected categories."

# Require a flag specifying which set(s) to install
USAGE="Usage: $0 --essential|--addons|--dev|--good-to-have|--all (can combine multiple flags)"
if [[ $# -lt 1 ]]; then
    echo "Error: you must specify at least one package group to install."
    echo "$USAGE"
    exit 1
fi

# parse flags
INSTALL_PACMAN=false
INSTALL_AUR=false
INSTALL_ESS=false
INSTALL_ADDONS=false
INSTALL_DEV=false
INSTALL_GOOD=false
INSTALL_ALL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --essential) INSTALL_ESS=true; shift ;;
    --addons) INSTALL_ADDONS=true; shift ;;
    --dev) INSTALL_DEV=true; shift ;;
    --good-to-have) INSTALL_GOOD=true; shift ;;
    --all) INSTALL_ALL=true; shift ;;
    --help|-h) echo "$USAGE"; exit 0 ;;
    *) echo "Unknown option: $1"; echo "$USAGE"; exit 1 ;;
  esac
done

if [[ "$INSTALL_ALL" == true ]]; then
  INSTALL_ESS=true; INSTALL_ADDONS=true; INSTALL_DEV=true; INSTALL_GOOD=true
fi

if [[ "$INSTALL_ESS" == false && "$INSTALL_ADDONS" == false && "$INSTALL_DEV" == false && "$INSTALL_GOOD" == false ]]; then
  echo "Error: no package groups selected. $USAGE"
  exit 1
fi

read -p "Continue and allow use of sudo for system operations? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted by user."
    exit 1
fi

# Update system (requires sudo)
echo "Updating system... (requires sudo)"
sudo pacman -Syu --noconfirm

# Ensure git and base-devel are installed for building AUR packages
echo "Ensuring git and base-devel are installed... (requires sudo)"
sudo pacman -S --noconfirm --needed git base-devel

# Check if yay is installed; if not, build it in a temp dir as the current user
if ! command -v yay &> /dev/null; then
    echo "yay not found, building and installing yay as current user..."
    TMPDIR="$(mktemp -d)"
    echo "Using temporary directory: $TMPDIR"
    git clone https://aur.archlinux.org/yay-bin.git "$TMPDIR/yay-bin"
    pushd "$TMPDIR/yay-bin" >/dev/null
    # makepkg must NOT be run as root; we're the normal user so it's fine
    makepkg -si --noconfirm
    popd >/dev/null
    rm -rf "$TMPDIR"
fi

# Build combined package list based on selected groups
PKGS=()
append_unique() {
  local file="$1"
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    # skip comments
    [[ "$p" =~ ^# ]] && continue
    # avoid duplicates
    if [[ ! " ${PKGS[*]} " =~ " ${p} " ]]; then
      PKGS+=("$p")
    fi
  done < "$file"
}

# helper files for categorized pkglists
ESS_FILE="$PKG_DIR/pkglist.essential.txt"
ADD_FILE="$PKG_DIR/pkglist.addons.txt"
DEV_FILE="$PKG_DIR/pkglist.dev.txt"
GOOD_FILE="$PKG_DIR/pkglist.good-to-have.txt"

if [[ "$INSTALL_ESS" == true ]]; then
  [[ -f "$ESS_FILE" ]] || { echo "Missing $ESS_FILE"; exit 1; }
  append_unique "$ESS_FILE"
fi
if [[ "$INSTALL_ADDONS" == true ]]; then
  [[ -f "$ADD_FILE" ]] || { echo "Missing $ADD_FILE"; exit 1; }
  append_unique "$ADD_FILE"
fi
if [[ "$INSTALL_DEV" == true ]]; then
  [[ -f "$DEV_FILE" ]] || { echo "Missing $DEV_FILE"; exit 1; }
  append_unique "$DEV_FILE"
fi
if [[ "$INSTALL_GOOD" == true ]]; then
  [[ -f "$GOOD_FILE" ]] || { echo "Missing $GOOD_FILE"; exit 1; }
  append_unique "$GOOD_FILE"
fi

if [[ ${#PKGS[@]} -eq 0 ]]; then
  echo "No packages selected to install after processing categories. Exiting."
  exit 0
fi

# Separate pacman-repo packages and AUR (foreign) packages using explicit lists
mapfile -t PACMAN_EXPLICIT < <(grep -E -v '^\s*(#|$)' "$PACMAN_PKGFILE" || true)
mapfile -t AUR_EXPLICIT < <(grep -E -v '^\s*(#|$)' "$AUR_PKGFILE" || true)

TO_INSTALL_PACMAN=()
TO_INSTALL_AUR=()
for p in "${PKGS[@]}"; do
  if printf '%s
' "${AUR_EXPLICIT[@]}" | grep -Fxq "$p"; then
    TO_INSTALL_AUR+=("$p")
  else
    TO_INSTALL_PACMAN+=("$p")
  fi
done

# Install pacman repo packages via sudo pacman
if [[ ${#TO_INSTALL_PACMAN[@]} -gt 0 ]]; then
  echo "Installing pacman repo packages (sudo will be used)..."
  sudo pacman -S --noconfirm --needed "${TO_INSTALL_PACMAN[@]}"
fi

# Install AUR packages via yay as user
if [[ ${#TO_INSTALL_AUR[@]} -gt 0 ]]; then
  if ! command -v yay &> /dev/null; then
    echo "yay not found after earlier steps — aborting AUR installs"
    exit 1
  fi
  echo "Installing AUR packages via yay..."
  for p in "${TO_INSTALL_AUR[@]}"; do
    yay -S --noconfirm --needed "$p"
  done
fi

echo "All done!"

echo "All done!"
