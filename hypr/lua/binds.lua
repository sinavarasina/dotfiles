-- lua/binds.lua — Keybindings

local core      = require("lua.core")
local acts      = require("lua.actions")

local c         = core.c
local app       = core.app
local key       = core.key.join

local M         = c.mod.main

local layout    = hl.dsp.layout
local focus     = hl.dsp.focus
local window    = hl.dsp.window
local workspace = hl.dsp.workspace

-- Core apps
hl.bind(key(M, "Q"), hl.dsp.exec_cmd(app.terminal))
hl.bind(key(M, "C"), window.close())
hl.bind(key(M, c.mod.shift, "C"), acts.force_kill_active())
hl.bind(key(M, c.mod.alt, "F4"), hl.dsp.exit())
hl.bind(key(M, "E"), hl.dsp.exec_cmd(app.file_manager))
hl.bind(key(M, "R"), hl.dsp.exec_cmd(app.menu))
hl.bind(key(M, "W"), hl.dsp.exec_cmd(app.web_browser))
hl.bind(key(M, c.mod.shift, "W"), hl.dsp.exec_cmd(app.web_browser_prv))

-- Layout switch
hl.bind(
    key(M, c.mod.alt, "D"),
    hl.dsp.exec_cmd("hyprctl keyword general:layout " .. c.layout.dwindle)
)
hl.bind(
    key(M, c.mod.alt, "M"),
    hl.dsp.exec_cmd("hyprctl keyword general:layout " .. c.layout.master)
)
hl.bind(
    key(M, c.mod.alt, "O"),
    hl.dsp.exec_cmd("hyprctl keyword general:layout " .. c.layout.monocle)
)
hl.bind(
    key(M, c.mod.alt, "S"),
    hl.dsp.exec_cmd("hyprctl keyword general:layout " .. c.layout.scrolling)
)
hl.bind(key(M, "P"), window.pseudo())

-- Master nav
hl.bind(key(M, "Return"), layout("swapwithmaster"))
hl.bind(key(M, c.mod.ctrl, "Return"), layout("focusmaster auto"))
hl.bind(key(M, c.mod.ctrl, "comma"), layout("addmaster"))
hl.bind(key(M, c.mod.ctrl, "period"), layout("removemaster"))
hl.bind(key(M, c.mod.ctrl, "TAB"), layout("orientationnext"))

-- Scroll nav
hl.bind(key(M, "period"), layout("move +col"))
hl.bind(key(M, "comma"), layout("move -col"))
hl.bind(key(M, c.mod.shift, "period"), layout("swapcol r"))
hl.bind(key(M, c.mod.shift, "comma"), layout("swapcol l"))

-- Monocle nav
hl.bind(key(M, "bracketright"), layout("cyclenext"))
hl.bind(key(M, "bracketleft"), layout("cycleprev"))

-- Move focus
hl.bind(key(M, "H"), focus({ direction = c.direction.left, }))
hl.bind(key(M, "J"), focus({ direction = c.direction.down, }))
hl.bind(key(M, "K"), focus({ direction = c.direction.up, }))
hl.bind(key(M, "L"), focus({ direction = c.direction.right, }))

-- Resize window
hl.bind(
    key(M, c.mod.shift, "H"),
    window.resize({ x = c.axis.left.x, y = c.axis.left.y, relative = true, }),
    { repeating = true, }
)
hl.bind(
    key(M, c.mod.shift, "J"),
    window.resize({ x = c.axis.down.x, y = c.axis.down.y, relative = true, }),
    { repeating = true, }
)
hl.bind(
    key(M, c.mod.shift, "K"),
    window.resize({ x = c.axis.up.x, y = c.axis.up.y, relative = true, }),
    { repeating = true, }
)
hl.bind(
    key(M, c.mod.shift, "L"),
    window.resize({ x = c.axis.right.x, y = c.axis.right.y, relative = true, }),
    { repeating = true, }
)

-- Move floating window
hl.bind(
    key(M, c.mod.ctrl, "H"),
    window.move({ x = c.axis.left.x, y = c.axis.left.y, relative = true, }),
    { repeating = true, }
)
hl.bind(
    key(M, c.mod.ctrl, "J"),
    window.move({ x = c.axis.down.x, y = c.axis.down.y, relative = true, }),
    { repeating = true, }
)
hl.bind(
    key(M, c.mod.ctrl, "K"),
    window.move({ x = c.axis.up.x, y = c.axis.up.y, relative = true, }),
    { repeating = true, }
)
hl.bind(
    key(M, c.mod.ctrl, "L"),
    window.move({ x = c.axis.right.x, y = c.axis.right.y, relative = true, }),
    { repeating = true, }
)

-- Swap current window with next / previous window
hl.bind(key(M, "TAB"), window.swap({ next = true, }))
hl.bind(key(M, c.mod.shift, "TAB"), window.swap({ prev = true, }))

-- Directional window swap
hl.bind(
    key(M, c.mod.ctrl, c.mod.shift, "H"),
    window.swap({ direction = c.direction.left, })
)
hl.bind(
    key(M, c.mod.ctrl, c.mod.shift, "J"),
    window.swap({ direction = c.direction.down, })
)
hl.bind(
    key(M, c.mod.ctrl, c.mod.shift, "K"),
    window.swap({ direction = c.direction.up, })
)
hl.bind(
    key(M, c.mod.ctrl, c.mod.shift, "L"),
    window.swap({ direction = c.direction.right, })
)

-- Dwindle split management
hl.bind(key(M, c.mod.ctrl, "S"), layout("togglesplit"))
hl.bind(key(M, c.mod.ctrl, c.mod.shift, "S"), layout("swapsplit"))

-- Preselect next split direction
hl.bind(key(M, c.mod.ctrl, "left"), layout("preselect l"))
hl.bind(key(M, c.mod.ctrl, "down"), layout("preselect d"))
hl.bind(key(M, c.mod.ctrl, "up"), layout("preselect u"))
hl.bind(key(M, c.mod.ctrl, "right"), layout("preselect r"))

-- Split ratio
hl.bind(key(M, c.mod.ctrl, "minus"), layout("splitratio -0.1"))
hl.bind(key(M, c.mod.ctrl, "equal"), layout("splitratio +0.1"))
hl.bind(key(M, c.mod.ctrl, "R"), layout("splitratio 1.0 exact"))

-- Fullscreen, Maximize, Float
hl.bind(key(M, "F"), window.fullscreen({ mode = "fullscreen", }))
hl.bind(key(M, c.mod.alt, "F"), window.fullscreen({ mode = "maximized", }))
hl.bind(key(M, c.mod.shift, "F"), window.float({ action = "toggle", }))

-- Switch workspaces
for i = 1, 9 do
    local ws = tostring(i)
    hl.bind(key(M, ws), focus({ workspace = ws, }))
    hl.bind(key(M, c.mod.shift, ws), window.move({ workspace = ws, }))
end

hl.bind(key(M, "0"), focus({ workspace = c.workspace.game, }))
hl.bind(key(M, c.mod.shift, "0"), window.move({ workspace = c.workspace.game, }))

-- Special workspace
hl.bind(key(M, "S"), workspace.toggle_special(c.workspace.special_name))
hl.bind(key(M, c.mod.shift, "S"),
    window.move({ workspace = c.workspace.special, }))

-- Mouse workspace scroll
hl.bind(key(M, c.mouse.down), focus({ workspace = "e+1", }))
hl.bind(key(M, c.mouse.up), focus({ workspace = "e-1", }))

-- Mouse actions
hl.bind(key(M, c.mouse.middle), window.pin())
hl.bind(key(M, c.mouse.left), window.drag(), { mouse = true, })
hl.bind(key(M, c.mouse.right), window.resize(), { mouse = true, })

-- UI toggles
hl.bind(key(M, c.mod.alt, "B"), hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Screenshots & utils
hl.bind(key(M, "print"), acts.screenshot_full())
hl.bind(key(M, c.mod.shift, "print"), acts.screenshot_area())
hl.bind(key(M, c.mod.alt, "P"), acts.color_picker())

-- Multimedia & TUI apps
hl.bind(key(M, c.mod.shift, "M"), hl.dsp.exec_cmd(app.music_player))
hl.bind(key(M, c.mod.ctrl, "V"), hl.dsp.exec_cmd(app.volume_manager))
hl.bind(key(M, c.mod.alt, "V"), hl.dsp.exec_cmd(app.watch_anime))
hl.bind(key(M, c.mod.ctrl, "M"), hl.dsp.exec_cmd(app.udiskstui))
hl.bind(key(M, c.mod.alt, "L"), hl.dsp.exec_cmd(app.mpd_lyrics))
hl.bind(key(M, "Z"), hl.dsp.exec_cmd(app.screen_zoom))
