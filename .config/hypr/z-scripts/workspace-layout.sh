#!/bin/bash
# Workspace layout initialization script

# Store current workspace to return to it later
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Workspace 1: Browser
hyprctl dispatch workspace 1
hyprctl dispatch exec chromium
sleep 2

# Workspace 2: Browser with email (left), WhatsApp + Teams (right)
hyprctl dispatch workspace 2
hyprctl dispatch exec "chromium --new-window https://mail.google.com https://venisocom.sharepoint.com/"
sleep 1

# Launch and group whatsapp & Teams together
hyprctl dispatch exec "gtk-launch WhatsApp.desktop"
sleep 0.5
hyprctl dispatch focuswindow "chrome-web.whatsapp.com__-Default"
sleep 0.5
hyprctl dispatch togglegroup
sleep 0.5
hyprctl dispatch exec "gtk-launch Teams.desktop"
sleep 1

# Workspace 3: Terminal with tmux
hyprctl dispatch workspace 3
# hyprctl dispatch exec "kitty -e bash -c 'tmux attach || tmux'"
hyprctl dispatch exec -- kitty -- herdr
sleep 0.5

# Workspace 6: Grok
hyprctl dispatch workspace 6
hyprctl dispatch exec "gtk-launch Grok.desktop"
sleep 0.5

# Workspace 9: Discord
hyprctl dispatch workspace 9
hyprctl dispatch exec "gtk-launch Discord.desktop"
sleep 1

# Return to the original workspace
hyprctl dispatch workspace "$current_workspace"
