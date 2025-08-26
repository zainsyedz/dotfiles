#!/usr/bin/env bash
# Lists explicitly installed packages:
# - explicit-pacman.txt  : explicit packages from pacman (repo packages)
# - explicit-aur.txt     : explicit foreign packages (AUR/foreign)
# - explicit-all.txt     : union of both (no longer generated)

set -euo pipefail

# Place outputs in the scripts/packages_required folder (repo layout changed)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Desired folder: scripts/packages_required
OUT_DIR="$SCRIPT_DIR/packages_required"
# ensure output dir exists
mkdir -p "$OUT_DIR"
PACMAN_EXPLICIT="$OUT_DIR/explicit-pacman.txt"
AUR_EXPLICIT="$OUT_DIR/explicit-aur.txt"
# No pkglist merging here (you removed that logic). This script only generates the explicit lists.

# Explicit packages (installed explicitly via pacman)
# pacman -Qe lists explicitly installed packages (includes foreign too)
pacman -Qe --color=never | awk '{print $1}' > "$PACMAN_EXPLICIT.tmp"

# Foreign packages (not in sync repos) — typically AUR or manually installed
pacman -Qm --color=never | awk '{print $1}' > "$OUT_DIR/foreign.tmp"

# The explicit AUR/foreign packages are the intersection of both lists
# (packages that are foreign AND marked explicit)
grep -Fx -f "$OUT_DIR/foreign.tmp" "$PACMAN_EXPLICIT.tmp" > "$AUR_EXPLICIT"

# Explicit pacman repo packages = explicit minus foreign
grep -Fxv -f "$OUT_DIR/foreign.tmp" "$PACMAN_EXPLICIT.tmp" > "$PACMAN_EXPLICIT"

# Cleanup tmps
rm -f "$OUT_DIR/foreign.tmp" "$PACMAN_EXPLICIT.tmp"

# Deduplicate and sort final outputs
sort -u -o "$PACMAN_EXPLICIT" "$PACMAN_EXPLICIT"
sort -u -o "$AUR_EXPLICIT" "$AUR_EXPLICIT"

echo "Wrote:"
echo " - $PACMAN_EXPLICIT ($(wc -l < \"$PACMAN_EXPLICIT\" ) packages)"
echo " - $AUR_EXPLICIT ($(wc -l < \"$AUR_EXPLICIT\" ) packages)"

exit 0
