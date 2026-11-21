-- lua/core/palette.lua — Catppuccin Mocha (single source of truth for colors)

local M = {}

-- Accents / surfaces (hex, no "0x"/"#" prefix)
M.mauve    = "cba6f7"
M.lavender = "b4befe"
M.blue     = "89b4fa"
M.surface1 = "313244"
M.surface0 = "1e1e2e"
M.mantle   = "181825"
M.crust    = "11111b"

-- Semantic status colors (see also hypridle.conf)
M.alert_info    = "86cecb"
M.alert_warning = "ffaa00"
M.alert_error   = "e12885"

function M.rgb(hex)
    return "rgb(" .. hex .. ")"
end

function M.rgba(hex, alpha)
    return "rgba(" .. hex .. (alpha or "aa") .. ")"
end

return M
