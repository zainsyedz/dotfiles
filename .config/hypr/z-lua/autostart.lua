-- Converted from autostart.conf.

hl.on("hyprland.start", function()
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("~/.config/hypr/z-scripts/monitor-daemon.sh")
end)

-- Match the old `exec = ...` behavior: re-apply lid state on every config load.
hl.exec_cmd("~/.config/hypr/z-scripts/lid-switch.sh")
