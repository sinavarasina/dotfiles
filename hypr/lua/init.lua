-- lua/init.lua — Config orchestrator

local profile = require("lua.profile")
local module = require("lua.core.module")

module.load({
    "lua.env",
    "lua.options",
    "lua.monitors",
    "lua.rules",
    "lua.binds",
    "lua.autostart",
})

module.load(profile.extra)
