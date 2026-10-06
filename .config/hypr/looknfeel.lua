-- Personal look and behavior overrides. Loaded after Omarchy defaults.

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })

-- Quick launch, then a long, car-like deceleration into the destination.
hl.curve("workspaceBrake", { type = "bezier", points = { { 0.08, 1 }, { 0.2, 1 } } })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "workspaceBrake", style = "slide" })

hl.config({
  binds = {
    allow_workspace_cycles = true,
    pass_mouse_when_bound = false,
  },
})
