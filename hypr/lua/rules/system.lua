-- lua/rules/system.lua — System utility rules

local match = require("lua.core.match")
local class = match.class
local titled = match.titled

hl.window_rule({
    name = "fcitx5-pseudo",
    match = class("^fcitx5$"),
    pseudo = true,
})

hl.window_rule({
    name = "thunar-progress",
    match = titled("^(thunar)$", "^(File Operation Progress)$"),
    float = true,
})

hl.window_rule({
    name = "file-roller",
    match = class("^(org%.gnome%.FileRoller)$"),
    float = true,
})

hl.window_rule({
    name = "qalculate-qt",
    match = class("^(io%.github%.Qalculate%.qalculate-qt)$"),
    float = true,
    size = {
        640,
        360,
    },
})

hl.window_rule({
    name = "qalculate-gtk",
    match = class("^(qalculate-gtk)$"),
    float = true,
    size = {
        640,
        360,
    },
})

hl.window_rule({
    name = "usbimager-float",
    match = class("^(USBImager 1%.0%.10)$"),
    float = true,
})

hl.window_rule({
    name = "rquickshare",
    match = class("^([Rr]quickshare|R%-quick%-share)$"),
    float = true,
})
