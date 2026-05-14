local env = require("lua.core.env")

env.apply({
    { "QT_AUTO_SCREEN_SCALE_FACTOR",         "1", },
    { "QT_QPA_PLATFORM",                     "wayland;xcb", },
    { "QT_QPA_PLATFORMTHEME",                "qt6ct", },
    { "QT_SCALE_FACTOR",                     "1", },
    { "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1", },
})
