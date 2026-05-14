local env = require("lua.core.env")

env.apply({
    { "CLUTTER_BACKEND", "wayland", },
    { "GDK_BACKEND",     "wayland,x11,*", },
    { "SDL_VIDEODRIVER", "wayland", },
    { "SDL_AUDIODRIVER", "pipewire", },
})
