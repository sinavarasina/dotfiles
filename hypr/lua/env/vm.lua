local core = require("lua.core")

local env = core.env

env.apply({
    { "LIBGL_ALWAYS_SOFTWARE",       "1", },
    { "WLR_RENDERER_ALLOW_SOFTWARE", "1", },
})
