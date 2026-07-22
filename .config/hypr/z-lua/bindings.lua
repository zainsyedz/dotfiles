-- Converted from bindings.conf and z-conf/keybindings/z-kb-likes.conf.

local mainMod = "SUPER"
local hyprscripts = "~/.config/hypr/z-scripts"
local terminal = "uwsm app -- $TERMINAL"
local browser = "omarchy-launch-browser"
local fileBrowser = "uwsm app -- nautilus"

local function bind(keys, dispatcher, opts)
    hl.bind(keys, dispatcher, opts)
end

local function exec(keys, cmd, opts)
    bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

for _, keys in ipairs({
    mainMod .. " + TAB",
    mainMod .. " + SHIFT + TAB",
    mainMod .. " + V",
    mainMod .. " + SHIFT + V",
    mainMod .. " + h",
    mainMod .. " + l",
    mainMod .. " + L",
    mainMod .. " + K",
    mainMod .. " + J",
    mainMod .. " + F",
    mainMod .. " + up",
    mainMod .. " + UP",
    mainMod .. " + down",
    mainMod .. " + DOWN",
    mainMod .. " + CTRL + TAB",
    mainMod .. " + CTRL + L",
}) do
    hl.unbind(keys)
end

exec(mainMod .. " + RETURN", terminal, { description = "Terminal" })
exec(mainMod .. " + ALT + RETURN", "uwsm-app -- xdg-terminal-exec --dir=\"$(omarchy-cmd-terminal-cwd)\" tmux new", { description = "Tmux" })
exec(mainMod .. " + B", browser, { description = "Browser" })
exec(mainMod .. " + E", fileBrowser)

bind(mainMod .. " + Q", hl.dsp.window.close())
exec(mainMod .. " + SHIFT + Q", "hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill")
bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
exec(mainMod .. " + SHIFT + V", "omarchy-launch-walker -m clipboard", { description = "Clipboard manager" })
exec(mainMod .. " + SHIFT + T", "hyprctl dispatch workspaceopt allfloat")
bind(mainMod .. " + DOWN", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
bind(mainMod .. " + ALT + G", hl.dsp.window.move({ out_of_group = true }), { description = "Move active window out of group" })
bind(mainMod .. " + UP", hl.dsp.layout("swapsplit"))

exec(mainMod .. " + SHIFT + S", "~/.local/share/omarchy/bin/omarchy capture screenshot", { description = "Screenshot of region" })
exec(mainMod .. " + SHIFT + CTRL + T", "~/.local/share/omarchy/bin/omarchy capture text extraction", { description = "Extract text from screenshot" })

for i = 1, 10 do
    local key = i % 10
    bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    exec(mainMod .. " + CTRL + " .. key, hyprscripts .. "/moveTo.sh " .. i)
end

bind(mainMod .. " + CTRL + h", hl.dsp.focus({ workspace = "m-1" }))
bind(mainMod .. " + CTRL + l", hl.dsp.focus({ workspace = "m+1" }))
bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "m+1" }))
bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "m-1" }))
exec(mainMod .. " + CTRL + Tab", hyprscripts .. "/moveWorkspaceTo.sh")
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))

exec("XF86MonBrightnessUp", "brightnessctl -q s +10%", { repeating = true })
exec("XF86MonBrightnessDown", "brightnessctl -q s 10%-", { repeating = true })
exec("XF86AudioMicMute", hyprscripts .. "/toggle-mic-led.sh")
exec("XF86Calculator", "~/.config/ml4w/settings/calculator.sh")
exec("XF86Lock", "hyprlock")
exec("code:238", "brightnessctl -d smc::kbd_backlight s +10")
exec("code:237", "brightnessctl -d smc::kbd_backlight s 10-")

exec(mainMod .. " + SHIFT + CTRL + L", "hyprlock")
exec(mainMod .. " + CTRL + SHIFT + I", "~/.config/hypr/z-scripts/workspace-layout.sh", { description = "Launch workspace layout" })

exec("switch:on:Lid Switch", "~/.config/hypr/z-scripts/lid-switch.sh", { locked = true })
exec("switch:off:Lid Switch", "~/.config/hypr/z-scripts/lid-switch.sh", { locked = true })
