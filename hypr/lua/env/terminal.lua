local core = require("lua.core")

local env = core.env

local app = core.app

env.apply({
    { "TerminalEmulator", app.terminal, },
    { "TERMINAL",         app.terminal, },
    -- { "KITTY_ENABLE_WAYLAND", "1" },
})
