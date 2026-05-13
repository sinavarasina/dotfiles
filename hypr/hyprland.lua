-- ============================================================
--  sina_varasina — Hyprland 0.55+ Lua Config
--  "i just tryin' eat my own rice"
-- ============================================================

local config_dir = os.getenv("HOME") .. "/.config/hypr"
package.path = config_dir .. "/?.lua;" .. package.path

-- load order
require("lua.globals")
require("lua.env")
require("lua.options")
require("lua.monitors")
require("lua.rules")
require("lua.binds")
require("lua.autostart")
