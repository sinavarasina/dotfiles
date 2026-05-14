-- lua/options.lua — Core options

local core = require("lua.core")
local c = core.c

hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 1,
        border_size = 1,
        ["col.active_border"] = {
            colors = { "rgb(cba6f7)", "rgb(313244)", },
            angle = 45,
        },
        ["col.inactive_border"] = "rgb(181825)",
        resize_on_border = true,
        allow_tearing = true,
        layout = c.layout.dwindle,
    },

    decoration = {
        rounding = 0,
        shadow = {
            enabled = true,
            range = 15,
            render_power = 2,
            color = "rgba(11111baa)",
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            noise = 0.03,
            contrast = 1.2,
            new_optimizations = true,
        },
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0.0,
        accel_profile = "flat",
        touchpad = { natural_scroll = false, },
    },

    dwindle = {
        preserve_split = true,
        smart_split = true,
        smart_resizing = true,
        force_split = 0,
        special_scale_factor = 0.8,
        permanent_direction_override = false,
        precise_mouse_move = true,
    },

    master = {
        new_status = "slave",
        allow_small_split = true,
        mfact = 0.55,
        new_on_top = true,
    },

    misc = {
        disable_hyprland_logo = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },

    render = {
        direct_scanout = 2,
        ctm_animation = 2,
        cm_enabled = 1,
        send_content_type = true,
    },

    cursor = {
        no_hardware_cursors = 2,
        no_break_fs_vrr = 2,
        enable_hyprcursor = true,
        hide_on_touch = true,
    },

    xwayland = {
        force_zero_scaling = false,
        create_abstract_socket = true,
    },

    debug = {
        full_cm_proto = true,
    },
})

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5, })

hl.curve("easeOutExpo", {
    type = "bezier",
    points = { { 0.05, 0.9, }, { 0.1, 1.0, }, },
})

local animations = {
    {
        leaf = "windows",
        enabled = true,
        speed = 0.5,
        bezier = "easeOutExpo",
        style = "slide",
    },
    {
        leaf = "windowsOut",
        enabled = true,
        speed = 0.5,
        bezier = "easeOutExpo",
        style = "slide",
    },
    {
        leaf = "windowsMove",
        enabled = true,
        speed = 1.0,
        bezier = "easeOutExpo",
    },
    {
        leaf = "fade",
        enabled = true,
        speed = 0.5,
        bezier = "easeOutExpo",
    },
    {
        leaf = "workspaces",
        enabled = true,
        speed = 1.0,
        bezier = "easeOutExpo",
        style = "slide",
    },
    {
        leaf = "layers",
        enabled = true,
        speed = 0.5,
        bezier = "easeOutExpo",
        style = "fade",
    },
    {
        leaf = "specialWorkspace",
        enabled = true,
        speed = 0.5,
        bezier = "easeOutExpo",
        style = "slidevert",
    },
    { leaf = "border",      enabled = false, },
    { leaf = "borderangle", enabled = false, },
}

for _, animation in ipairs(animations) do
    hl.animation(animation)
end
