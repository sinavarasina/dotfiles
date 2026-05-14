-- ============================================================
--  sina_varasina — Hyprland 0.55+ Lua Config
--  "i just tryin' eat my own rice"
-- ============================================================

local home = assert(os.getenv("HOME"), "HOME is not set")
local config_dir = home .. "/.config/hypr"

package.path = table.concat({
    config_dir .. "/?.lua",
    config_dir .. "/?/init.lua",
    package.path,
}, ";")

require("lua")
