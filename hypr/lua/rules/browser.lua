-- lua/rules/browser.lua — Browser rules

local core = require("lua.core")
local match = core.match
local titled = match.titled

hl.window_rule({
    name = "firefox-pip",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    size = "monitor_w*0.3333 monitor_h*0.3333",
    move = "6 monitor_h-window_h-6",
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
