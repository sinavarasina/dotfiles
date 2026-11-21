-- lua/monitors/mi-g24i.lua — Xiaomi Mi G24i (DP-1)

local core = require("lua.core")

local path = core.path

local output = "desc:Xiaomi Corporation Mi Monitor 5790020017103"
local mode = "1920x1080@180"
local icc = path.dir.dotfiles .. "/ColorProfile/G24i-lordkutang.icm"

hl.monitor({
    output = output,
    mode = mode,
    position = "auto",
    scale = 1,
    bitdepth = 10,
    icc = icc,
    cm = "hdr",
})

-- Variants: drop `icc`/`cm`/`bitdepth` for plain SDR, or keep `bitdepth` +
-- `cm = "auto"` (+ optional `sdrbrightness = 1.1`) for SDR-on-HDR-capable
-- panels without the ICC profile.
