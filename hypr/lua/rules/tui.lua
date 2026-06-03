-- lua/rules/tui.lua — Floating TUI and custom script rules

local match = require("lua.core.match")
local class = match.class
local titled = match.titled

hl.window_rule({
    name = "ncmpcpp-keybind",
    match = class("^(ncmpcpp-float-key)$"),
    float = true,
    size = {
        1120,
        480,
    },
})

hl.window_rule({
    name = "sptlrx-keybind",
    match = class("^(mpd_lyrics)$"),
    float = true,
    size = {
        380,
        1053,
    },
    move = {
        1539,
        25,
    },
})

hl.window_rule({
    name = "alsamixer-keybind",
    match = class("^(alsamixer-float)$"),
    float = true,
    size = {
        111,
        320,
    },
    move = {
        3,
        29,
    },
})

hl.window_rule({
    name = "ani-cli-keybind",
    match = class("^(ani-cli-float)$"),
    float = true,
    size = {
        476,
        155,
    },
    move = {
        728,
        28,
    },
})

hl.window_rule({
    name = "udisktui-rules",
    match = class("^(udiskstui)$"),
    float = true,
    center = true,
    size = {
        1000,
        300,
    },
})

hl.window_rule({
    name = "hyprpwcenter",
    match = titled("hyprpwcenter", "Pipewire Control Center"),
    float = true,
    center = true,
    max_size = {
        1366,
        600,
    },
    no_anim = true,
})
