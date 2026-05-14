local env = require("lua.core.env")

env.apply({
    { "HSA_OVERRIDE_GFX_VERSION", "10.3.0", },
    { "AMD_VULKAN_ICD",           "RADV", },
    { "RADV_PERFTEST",            "gpl", },
    { "LIBVA_DRIVER_NAME",        "radeonsi", },
    { "VDPAU_DRIVER",             "radeonsi", },
})
