-- lua/extra/portal_workaround.lua — XDPH restart workaround

local sh = require("lua.core.shell")

hl.on("hyprland.start", function()
    sh.exec([[
sleep 1
killall -e xdg-desktop-portal-hyprland 2>/dev/null || true
killall xdg-desktop-portal 2>/dev/null || true
/usr/libexec/xdg-desktop-portal-hyprland &
sleep 2
/usr/libexec/xdg-desktop-portal &
]])
end)
