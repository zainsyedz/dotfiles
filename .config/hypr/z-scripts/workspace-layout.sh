#!/bin/bash
# Workspace layout initialization script

# Store current workspace to return to it later
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

dispatch_workspace() {
    hyprctl dispatch "hl.dsp.focus({ workspace = $1 })"
}

dispatch_exec() {
    local cmd=${1//\\/\\\\}
    cmd=${cmd//\"/\\\"}
    hyprctl dispatch "hl.dsp.exec_cmd(\"$cmd\")"
}

# Workspace 1: Browser
dispatch_workspace 1
dispatch_exec "chromium"
sleep 2

# Workspace 2: Browser with email (left), WhatsApp + Teams (right)
dispatch_workspace 2
dispatch_exec "chromium --new-window https://mail.google.com https://venisocom.sharepoint.com/"
sleep 1

# Launch and group whatsapp & Teams together
dispatch_exec "gtk-launch WhatsApp.desktop"
sleep 1
hyprctl dispatch 'hl.dsp.focus({ window = "class:chrome-web.whatsapp.com__-Default" })'
sleep 1
hyprctl dispatch 'hl.dsp.group.toggle()'
sleep 1
dispatch_exec "gtk-launch Teams.desktop"
sleep 1

# Workspace 3: Terminal with tmux
dispatch_workspace 3
dispatch_exec "kitty -- herdr"
sleep 1

# Workspace 6: Grok
dispatch_workspace 6
dispatch_exec "gtk-launch Grok.desktop"
sleep 1

# Workspace 9: Discord
dispatch_workspace 9
dispatch_exec "gtk-launch Discord.desktop"
sleep 1

# Return to the original workspace
dispatch_workspace "$current_workspace"
