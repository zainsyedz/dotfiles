-- Converted from looknfeel.conf, z-decLikes.conf, and z-winLikes.conf.

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })

hl.config({
    binds = {
        allow_workspace_cycles = true,
        pass_mouse_when_bound  = false,
    },
})

-- The old decoration/general/group blocks only contained commented examples, so
-- no active visual settings are emitted here.
