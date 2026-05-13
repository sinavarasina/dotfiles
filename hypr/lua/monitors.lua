-- ============================================================
--  lua/monitors.lua — Monitor Setup
-- ============================================================

-- Primary monitor
hl.monitor({
    output   = "desc:Xiaomi Corporation Mi Monitor 5790020017103",
    mode     = "1920x1080@180",
    position = "auto",
    scale    = 1,
    bitdepth = 10,
    icc      = os.getenv("HOME") .. "/dotfiles/ColorProfile/G24i-lordkutang.icm",
})

-- Standard SDR
-- hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor 5790020017103", mode = "1920x1080@180", position = "auto", scale = 1 })

-- Auto CM
-- hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor 5790020017103", mode = "1920x1080@180", position = "auto", scale = 1, bitdepth = 10, cm = "auto" })

-- HDR with SDR boost
-- hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor 5790020017103", mode = "1920x1080@180", position = "auto", scale = 1, bitdepth = 10, cm = "hdr", sdrbrightness = 1.1 })
