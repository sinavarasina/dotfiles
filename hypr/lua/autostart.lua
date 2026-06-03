-- lua/autostart.lua — Startup applications

local path = require("lua.core.paths")
local sh = require("lua.core.shell")

local exec_once = sh.exec_once

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    exec_once("fcitx5")
    exec_once("hypridle")
    exec_once("waybar")
    exec_once("dunst")
    exec_once("thunar", "thunar --daemon")
    exec_once("foot", "foot --server")
    exec_once("swaybg",
        "swaybg -i " .. sh.quote(path.file.wallpaper) .. " -m fill")
end)
