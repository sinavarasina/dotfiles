local env = require("lua.core.env")

env.apply({
    { "MOZ_ENABLE_WAYLAND", "1", },
})
