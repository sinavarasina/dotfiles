-- lua/rules/browser.lua — Browser rules

local match = require("lua.core.match")
local titled = match.titled

hl.window_rule({
    name = "firefox-pip",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    size = {
        640,
        360,
    },
    move = {
        6,
        714,
    },
    opacity = 1.0,
})

hl.window_rule({
    name = "firefox-aria2",
    match = titled("^firefox$", "^Extension: %(Aria2 Integration%)"),
    float = true,
    center = true,
    size = {
        360,
        305,
    },
})
