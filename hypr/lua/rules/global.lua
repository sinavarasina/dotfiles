-- lua/rules/global.lua — Global window rules

local match = require("lua.core.match")
local class = match.class

hl.window_rule({
    match = { float = false, workspace = "w[tv1]s[false]", },
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    match = { float = false, workspace = "f[1]s[false]", },
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name = "global-suppress-maximize",
    match = class(".*"),
    suppress_event = "maximize",
})
