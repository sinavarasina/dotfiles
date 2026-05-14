local env = require("lua.core.env")

env.apply({
    { "LIBVA_DRIVER_NAME",         "nvidia", },
    { "__GLX_VENDOR_LIBRARY_NAME", "nvidia", },
    { "NVD_BACKEND",               "direct", },
    { "GBM_BACKEND",               "nvidia-drm", },
    { "__NV_PRIME_RENDER_OFFLOAD", "1", },
    { "__VK_LAYER_NV_optimus",     "NVIDIA_only", },
    { "MOZ_DISABLE_RDD_SANDBOX",   "1", },
    { "EGL_PLATFORM",              "wayland", },
})
