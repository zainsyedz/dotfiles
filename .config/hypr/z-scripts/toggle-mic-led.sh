#!/bin/bash
# Toggle microphone and sync LED
# wpctl set-mute @DEFAULT_SOURCE@ toggle
if wpctl get-volume @DEFAULT_SOURCE@ | grep -q "\[MUTED\]"; then
    echo 1 | sudo tee /sys/class/leds/platform::micmute/brightness
else
    echo 0 | sudo tee /sys/class/leds/platform::micmute/brightness
fi
