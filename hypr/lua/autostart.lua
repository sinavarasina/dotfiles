-- lua/autostart.lua — Startup applications

local core = require("lua.core")
local path = core.path
local sh = core.shell

local exec_once = sh.exec_once

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    exec_once("fcitx5")
    exec_once("wl-clip-persist", "wl-clip-persist --clipboard regular")
    exec_once("hypridle")
    exec_once("sina-desktop-widget", path.file.widget)
    exec_once("thunar", "thunar --daemon")
    exec_once("foot", "foot --server")
end)
