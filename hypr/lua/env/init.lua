-- lua/env/init.lua — Environment module loader

local profile = require("lua.profile")
local core = require("lua.core")

local module = core.module

module.load_named("lua.env", profile.env)
