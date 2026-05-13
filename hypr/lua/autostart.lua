-- ============================================================
--  lua/autostart.lua — Startup Applications
-- ============================================================

hl.on("hyprland.start", function()
    -- Services & shell
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("thunar --daemon")
    hl.exec_cmd("foot --server")
    hl.exec_cmd("swaybg -i " .. V.wallpaper .. " -m fill")

    -- Automount
    -- hl.exec_cmd("udisksctl mount --block-device /dev/disk/by-uuid/27ccb7d1-49c2-4d6e-9e4f-a3249383547b --no-user-interaction")
    -- hl.exec_cmd("udisksctl mount --block-device /dev/disk/by-uuid/b49bd13f-2c80-40b3-bfb2-6748dd9fa0c2 --no-user-interaction")

    -- XDPH
    -- hl.exec_cmd("sh -c 'sleep 1 && killall -e xdg-desktop-portal-hyprland && killall xdg-desktop-portal && /usr/libexec/xdg-desktop-portal-hyprland & sleep 2 && /usr/libexec/xdg-desktop-portal &'")
end)
