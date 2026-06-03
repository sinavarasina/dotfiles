-- lua/rules/gaming.lua — Gaming rules

local core = require("lua.core")
local c = core.c
local match = core.match
local class = match.class
local titled = match.titled

hl.window_rule({
    name = "steam-popups",
    match = titled("^steam.*", "^(Steam Settings|Friends List)$"),
    float = true,
})

hl.window_rule({
    name = "steam-big-picture",
    match = { title = "^Steam Big Picture Mode$", },
    workspace = c.workspace.game,
    fullscreen = true,
    fullscreen_state = c.fullscreen_state.fullscreen,
    tile = true,
})

hl.window_rule({
    name = "steam-game-mode",
    match = class("steam_app_1446780"),
    content = "game",
    fullscreen_state = c.fullscreen_state.fullscreen,
})
