-- Personal keybinding overrides. Loaded after Omarchy defaults.

local mainMod = "SUPER"
local hyprscripts = "~/.config/hypr/z-scripts"

local function bind(keys, description, dispatcher, opts)
  hl.unbind(keys)
  o.bind(keys, description, dispatcher, opts)
end

local function exec(keys, description, command, opts)
  bind(keys, description, command, opts)
end

for _, keys in ipairs({
  mainMod .. " + TAB",
  mainMod .. " + SHIFT + TAB",
  mainMod .. " + V",
  mainMod .. " + SHIFT + V",
  mainMod .. " + H",
  mainMod .. " + L",
  mainMod .. " + K",
  mainMod .. " + J",
  mainMod .. " + F",
  mainMod .. " + SHIFT + F",
  mainMod .. " + UP",
  mainMod .. " + DOWN",
  mainMod .. " + CTRL + TAB",
  mainMod .. " + CTRL + L",
}) do
  hl.unbind(keys)
end

exec(mainMod .. " + ALT + RETURN", "Tmux", "uwsm-app -- xdg-terminal-exec --dir=\"$(omarchy-cmd-terminal-cwd)\" tmux new")
exec(mainMod .. " + B", "Browser", "omarchy-launch-browser")
exec(mainMod .. " + E", "File manager", "uwsm-app -- nautilus")

bind(mainMod .. " + Q", "Close window", hl.dsp.window.close())
exec(mainMod .. " + SHIFT + Q", "Kill active window process", "hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill")
bind(mainMod .. " + F", "Maximize window", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
bind(mainMod .. " + SHIFT + F", "Fullscreen window", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bind(mainMod .. " + V", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
exec(mainMod .. " + SHIFT + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
exec(mainMod .. " + SHIFT + T", "Toggle all windows floating", "hyprctl dispatch workspaceopt allfloat")

bind(mainMod .. " + DOWN", "Toggle split", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + UP", "Swap split", hl.dsp.layout("swapsplit"))
bind(mainMod .. " + H", "Focus left", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + L", "Focus right", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + K", "Focus up", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + J", "Focus down", hl.dsp.focus({ direction = "d" }))

bind(mainMod .. " + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + SHIFT + l", "Increase window width", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
bind(mainMod .. " + SHIFT + h", "Reduce window width", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
bind(mainMod .. " + SHIFT + j", "Increase window height", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
bind(mainMod .. " + SHIFT + k", "Reduce window height", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
bind(mainMod .. " + ALT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))

exec(mainMod .. " + SHIFT + S", "Screenshot of region", "omarchy-capture-screenshot")
exec(mainMod .. " + SHIFT + CTRL + T", "Extract text from screenshot", "omarchy-capture-text")

for i = 1, 10 do
  local key = i % 10
  bind(mainMod .. " + " .. key, "Switch to workspace " .. i, hl.dsp.focus({ workspace = i }))
  bind(mainMod .. " + SHIFT + " .. key, "Move window to workspace " .. i, hl.dsp.window.move({ workspace = i }))
  exec(mainMod .. " + CTRL + " .. key, "Move all windows to workspace " .. i, hyprscripts .. "/moveTo.sh " .. i)
end

bind(mainMod .. " + CTRL + h", "Previous workspace on monitor", hl.dsp.focus({ workspace = "m-1" }))
bind(mainMod .. " + CTRL + l", "Next workspace on monitor", hl.dsp.focus({ workspace = "m+1" }))
bind(mainMod .. " + TAB", "Next workspace on monitor", hl.dsp.focus({ workspace = "m+1" }))
bind(mainMod .. " + SHIFT + TAB", "Previous workspace on monitor", hl.dsp.focus({ workspace = "m-1" }))
exec(mainMod .. " + CTRL + Tab", "Move workspace to next monitor", hyprscripts .. "/moveWorkspaceTo.sh")
bind(mainMod .. " + CTRL + down", "Open empty workspace", hl.dsp.focus({ workspace = "empty" }))

exec("XF86AudioMicMute", "Mute microphone", "omarchy-audio-input-mute && " .. hyprscripts .. "/toggle-mic-led.sh", { locked = true })
exec("XF86Calculator", "Calculator", "test -x ~/.config/ml4w/settings/calculator.sh && ~/.config/ml4w/settings/calculator.sh || gnome-calculator")
exec("code:238", "Keyboard brightness up", "brightnessctl -d smc::kbd_backlight s +10", { locked = true, repeating = true })
exec("code:237", "Keyboard brightness down", "brightnessctl -d smc::kbd_backlight s 10-", { locked = true, repeating = true })

exec(mainMod .. " + SHIFT + CTRL + L", "Lock system", "omarchy-system-lock")
exec(mainMod .. " + CTRL + SHIFT + I", "Launch workspace layout", "~/.config/hypr/z-scripts/workspace-layout.sh")

bind(
  "switch:on:Lid Switch",
  nil,
  "if omarchy-hyprland-monitor-external-active; then omarchy-hyprland-monitor-clamshell; else systemctl suspend; fi",
  { locked = true }
)
bind("switch:off:Lid Switch", nil, "omarchy-hyprland-monitor-clamshell", { locked = true })
