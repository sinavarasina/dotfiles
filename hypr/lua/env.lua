-- ============================================================
--  lua/env.lua — Environment Variables
-- ============================================================

-- Editor
hl.env("EDITOR", "nvim")

-- Wayland & display backends
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("SDL_AUDIODRIVER", "pipewire")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- XDG session
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- HiDPI / XWayland scale fix
hl.env("GDK_SCALE", "1")

-- Firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Electron (>28)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Cursor
hl.env("XCURSOR_THEME", "Hakurei Reimu")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Hakurei Reimu")
hl.env("HYPRCURSOR_SIZE", "24")

-- Terminal emulator
hl.env("TerminalEmulator", "footclient")
hl.env("TERMINAL", "footclient")
hl.env("KITTY_ENABLE_WAYLAND", "1")

-- MPD
hl.env("MPD_HOST", "0.0.0.0")
hl.env("MPD_PORT", "6600")

-- MangoHUD
hl.env("MANGOHUD", "0")
hl.env("MANGOHUD_DLSYM", "0")

-- AMD GPU
hl.env("HSA_OVERRIDE_GFX_VERSION", "10.3.0")
hl.env("AMD_VULKAN_ICD", "RADV")
hl.env("RADV_PERFTEST", "gpl")
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("VDPAU_DRIVER", "radeonsi")

-- HDR
hl.env("ENABLE_HDR_WSI", "1")
hl.env("DXVK_HDR", "1")

-- fcitx5 IME
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

-- NVIDIA (disabled)
-- hl.env("LIBVA_DRIVER_NAME",         "nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("NVD_BACKEND",               "direct")
-- hl.env("GBM_BACKEND",               "nvidia-drm")
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__VK_LAYER_NV_optimus",     "NVIDIA_only")
-- hl.env("MOZ_DISABLE_RDD_SANDBOX",   "1")
-- hl.env("EGL_PLATFORM",              "wayland")

-- VM / Software rendering (disabled)
-- hl.env("LIBGL_ALWAYS_SOFTWARE",         "1")
-- hl.env("WLR_RENDERER_ALLOW_SOFTWARE",   "1")
