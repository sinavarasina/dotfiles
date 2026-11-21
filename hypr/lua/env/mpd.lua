local core = require("lua.core")

local env = core.env

env.apply({
    { "MPD_HOST", "0.0.0.0", },
    { "MPD_PORT", "6600", },
})
