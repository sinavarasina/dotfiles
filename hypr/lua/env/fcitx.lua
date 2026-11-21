local core = require("lua.core")

local env = core.env

env.apply({
    { "QT_IM_MODULE",  "fcitx", },
    { "SDL_IM_MODULE", "fcitx", },
    { "XMODIFIERS",    "@im=fcitx", },
})
