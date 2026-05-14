local env = require("lua.core.env")

env.apply({
    { "XDG_CURRENT_DESKTOP", "Hyprland", },
    { "XDG_SESSION_DESKTOP", "Hyprland", },
    { "XDG_SESSION_TYPE",    "wayland", },
    { "GDK_SCALE",           "1", },
})
