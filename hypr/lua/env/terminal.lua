local env = require("lua.core.env")
local app = require("lua.core.apps")

env.apply({
    { "TerminalEmulator", app.terminal, },
    { "TERMINAL",         app.terminal, },
    -- { "KITTY_ENABLE_WAYLAND", "1" },
})
