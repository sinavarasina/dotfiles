-- lua/extra/portal_workaround.lua — XDPH restart workaround

hl.on("hyprland.start", function()
    hl.exec_cmd([[
        sh -c 'sleep 1 && \
        killall -e xdg-desktop-portal-hyprland && \
        killall xdg-desktop-portal && \
        /usr/libexec/xdg-desktop-portal-hyprland & \
        sleep 2 && \
        /usr/libexec/xdg-desktop-portal &'
    ]])
end)
