-- lua/extra/automount.lua — disk automount

local devices = {
    "27ccb7d1-49c2-4d6e-9e4f-a3249383547b",
    "b49bd13f-2c80-40b3-bfb2-6748dd9fa0c2",
}

hl.on("hyprland.start", function()
    for _, uuid in ipairs(devices) do
        hl.exec_cmd("udisksctl mount --block-device /dev/disk/by-uuid/" ..
            uuid .. " --no-user-interaction")
    end
end)
