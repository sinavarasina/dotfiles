local M = {}

M.mod = {
    main  = "SUPER",
    shift = "SHIFT",
    ctrl  = "CTRL",
    alt   = "ALT",
}

M.direction = {
    left  = "l",
    down  = "d",
    up    = "u",
    right = "r",
}

M.axis = {
    left  = { x = -5, y = 0, },
    right = { x = 5, y = 0, },
    up    = { x = 0, y = -5, },
    down  = { x = 0, y = 5, },
}

M.layout = {
    dwindle   = "dwindle",
    master    = "master",
    monocle   = "monocle",
    scrolling = "scrolling",
}

M.workspace = {
    special_name = "magic",
    special      = "special:magic",
    game         = "10",
}

M.fullscreen_state = {
    fullscreen = "3 3",
}

M.mouse = {
    left   = "mouse:272",
    right  = "mouse:273",
    middle = "mouse:274",
    up     = "mouse_up",
    down   = "mouse_down",
}

return M
