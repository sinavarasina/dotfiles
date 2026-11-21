local profile = require("lua.profile")
local core = require("lua.core")

local module = core.module

module.load_named("lua.monitors", profile.monitors)
