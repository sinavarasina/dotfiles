local profiles = require("lua.monitors.profiles")

local output = ""
local mode = "preferred"
local position = "auto"
local scale = 1

hl.monitor(profiles.sdr(output, mode, position, scale))
