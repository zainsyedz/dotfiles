-- Personal autostart additions. Loaded after Omarchy defaults.

hl.on("hyprland.start", function()
  -- Keep clipboard contents available after the source process exits.
  hl.exec_cmd("wl-clip-persist --clipboard regular")
end)
