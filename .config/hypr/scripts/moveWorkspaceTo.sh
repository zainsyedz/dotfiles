#!/bin/bash

# Function to log messages (useful for debugging)
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >&2
}

get_next_monitor() {
    monitor_count=${#monitors[@]}
    log_message "Monitor count $monitor_count"
    if [ $monitor_count -eq 1 ]; then
        log_message "Only one monitor. Exiting"
        exit 0
    elif [ $current_monitor_id -eq ${monitors[($monitor_count - 1)]} ]; then
        echo 0
    else
        echo $current_monitor_id + 1
    fi
}

# Get the current active workspace
current_workspace=$(hyprctl activewindow -j | jq '.workspace.id')

# Get the current monitor id
current_monitor_id=$(hyprctl activewindow -j | jq '.monitor')

# Get all monitor ids
monitors=( $(hyprctl monitors -j | jq -r ".[] | .id") )

next_monitor_id=$(get_next_monitor)
log_message "Moving to monitor with ID $next_monitor_id"
next_monitor=$(hyprctl monitors -j | jq -r ".[] | select(.id == $next_monitor_id) | .name")
log_message "Moving to monitor with name $next_monitor"
hyprctl dispatch movecurrentworkspacetomonitor "$next_monitor"
