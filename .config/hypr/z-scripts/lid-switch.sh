#!/bin/bash

# Lid switch handler for Hyprland
# Handles laptop lid close/open events with external monitor detection

# Get lid state from /proc/acpi/button/lid/LID*/state
LID_STATE=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')

# Check if external monitors are connected (anything other than eDP-1)
EXTERNAL_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -n 1)

if [ "$LID_STATE" = "closed" ]; then
    if [ -n "$EXTERNAL_MONITOR" ]; then
        # External monitor connected - disable internal display
        hyprctl keyword monitor "eDP-1,disable"
    else
        # No external monitor - suspend the system
        systemctl suspend
    fi
else
    # Lid is open - reload config to restore custom monitor settings (scale, position, etc.)
    hyprctl reload
fi
