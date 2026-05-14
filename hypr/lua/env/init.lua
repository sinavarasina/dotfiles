-- lua/env/init.lua — Environment module loader

local profile = require("lua.profile")
local module = require("lua.core.module")

module.load_named("lua.env", profile.env)
