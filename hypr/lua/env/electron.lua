local env = require("lua.core.env")

env.apply({
    { "ELECTRON_OZONE_PLATFORM_HINT", "auto", },
    { "GTK_USE_PORTAL",               "1", },
})
