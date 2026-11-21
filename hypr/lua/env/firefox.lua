local core = require("lua.core")

local env = core.env

env.apply({
    { "MOZ_ENABLE_WAYLAND", "1", },
})
