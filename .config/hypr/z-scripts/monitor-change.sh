#!/bin/bash

# Monitor change handler for Hyprland
# Handles monitor connect/disconnect events, especially when lid is closed

# Get lid state from /proc/acpi/button/lid/LID*/state
LID_STATE=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')

# Check if external monitors are connected (anything other than eDP-1)
EXTERNAL_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -n 1)

# Critical case: Lid is closed and NO external monitor
if [ "$LID_STATE" = "closed" ] && [ -z "$EXTERNAL_MONITOR" ]; then
    # Suspend immediately - user disconnected monitor with lid closed
    systemctl suspend
elif [ "$LID_STATE" = "closed" ] && [ -n "$EXTERNAL_MONITOR" ]; then
    # External monitor connected with lid closed - ensure internal is disabled
    hyprctl keyword monitor "eDP-1,disable"
fi
