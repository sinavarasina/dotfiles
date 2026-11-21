-- lua/rules/media.lua — Multimedia and viewer rules

local core = require("lua.core")
local match = core.match
local class = match.class
local titled = match.titled

hl.window_rule({
    name = "imv-rules",
    match = class("^(imv)$"),
    float = true,
    center = true,
    size = {
        900,
        600,
    },
    opacity = 1.0,
})

hl.window_rule({
    name = "mpv-rules",
    match = class("^(mpv)$"),
    float = true,
    center = true,
    max_size = "monitor_w monitor_h",
    opacity = 1.0,
})

hl.window_rule({
    name = "telegram-viewer",
    match = titled("^(org%.telegram%.desktop)$", "^(Media viewer)$"),
    float = true,
    max_size = {
        640,
        360,
    },
})
