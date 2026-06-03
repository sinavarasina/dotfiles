-- lua/extra/automount.lua — disk automount

local sh = require("lua.core.shell")

local devices = {
    "27ccb7d1-49c2-4d6e-9e4f-a3249383547b",
    "b49bd13f-2c80-40b3-bfb2-6748dd9fa0c2",
}

local by_uuid = "/dev/disk/by-uuid/"

hl.on("hyprland.start", function()
    for i = 1, #devices do
        local path = by_uuid .. devices[i]
        hl.exec_cmd("udisksctl mount --block-device " .. sh.quote(path) ..
            " --no-user-interaction")
    end
end)
