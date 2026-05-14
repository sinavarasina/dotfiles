local profiles = require("lua.monitors.profiles")

local output = "desc:Xiaomi Corporation Mi Monitor 5790020017103"
local mode = "1920x1080@180"

hl.monitor(profiles.icc(output, mode))

-- Alternative profiles:
-- hl.monitor(profiles.sdr(output, mode))
-- hl.monitor(profiles.auto_cm(output, mode))
-- hl.monitor(profiles.hdr(output, mode))
