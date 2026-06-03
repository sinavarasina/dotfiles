local path = require("lua.core.paths")

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
})

-- hl.monitor({
--     output = output,
--     mode = mode,
--     position = "auto",
--     scale = 1,
-- })
--
-- hl.monitor({
--     output = output,
--     mode = mode,
--     position = "auto",
--     scale = 1,
--     bitdepth = 10,
--     cm = "auto",
-- })
--
-- hl.monitor({
--     output = output,
--     mode = mode,
--     position = "auto",
--     scale = 1,
--     bitdepth = 10,
--     cm = "hdr",
--     sdrbrightness = 1.1,
-- })
