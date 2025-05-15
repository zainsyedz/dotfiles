#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root (use sudo)"
    exit 1
fi

# Update system first
echo "Updating system..."
pacman -Syu --noconfirm

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "Yay not found, installing..."
    sudo pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin && makepkg -si --noconfirm
    cd .. && rm -rf yay-bin
fi

# Install packages from the list
echo "Installing packages..."
yay -S --noconfirm --needed $(cat pkglist.txt)

echo "All done!"
