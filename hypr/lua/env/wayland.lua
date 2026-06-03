local env = require("lua.core.env")

env.apply({
    { "CLUTTER_BACKEND", "wayland", },
    { "GDK_BACKEND",     "wayland,x11,*", },
    { "SDL_VIDEODRIVER", "wayland,x11,windows", },
    { "SDL_AUDIODRIVER", "pipewire", },
})
