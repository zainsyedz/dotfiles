#!/bin/bash

# Monitor daemon for Hyprland
# Watches for monitor changes using hyprctl and triggers handler

# Function to get current monitor list (excluding eDP-1)
get_monitors() {
    hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | sort
}

# Initial state
PREV_MONITORS=$(get_monitors)

# Monitor loop - check every 2 seconds
while true; do
    sleep 2
    
    CURR_MONITORS=$(get_monitors)
    
    # Check if monitors changed
    if [ "$PREV_MONITORS" != "$CURR_MONITORS" ]; then
        # Monitors changed - run handler
        ~/.config/hypr/z-scripts/monitor-change.sh
        PREV_MONITORS="$CURR_MONITORS"
    fi
done
