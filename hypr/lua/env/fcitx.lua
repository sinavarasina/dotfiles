local env = require("lua.core.env")

env.apply({
    { "QT_IM_MODULE",  "fcitx", },
    { "SDL_IM_MODULE", "fcitx", },
    { "XMODIFIERS",    "@im=fcitx", },
})
