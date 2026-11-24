-- lua/binds.lua — Keybindings

local core = require("lua.core")
local acts = require("lua.actions")

local c = core.c
local app = core.app
local key = core.key.join

local dsp = hl.dsp
local win = dsp.window
local focus = dsp.focus

local mod = c.mod.main
local shift = c.mod.shift
local ctrl = c.mod.ctrl
local alt = c.mod.alt

-- Core apps
hl.bind(key(mod, "Q"), dsp.exec_cmd(app.terminal))
hl.bind(key(mod, "C"), win.close())
hl.bind(key(mod, shift, "C"), acts.force_kill_active())
hl.bind(key(mod, alt, "F4"), dsp.exit())
hl.bind(key(mod, "E"), dsp.exec_cmd(app.file_manager))
hl.bind(key(mod, "W"), dsp.exec_cmd(app.web_browser))
hl.bind(key(mod, shift, "W"), dsp.exec_cmd(app.web_browser_prv))

-- Layout switch (in-process via hl.config) & pseudo
local layouts = {
    { "D", c.layout.dwindle, },
    { "M", c.layout.master, },
    { "O", c.layout.monocle, },
    { "S", c.layout.scrolling, },
}

for i = 1, #layouts do
    local keystroke = layouts[i][1]
    local layout = layouts[i][2]
    hl.bind(key(mod, alt, keystroke),
        function() hl.config({ general = { layout = layout, }, }) end)
end

hl.bind(key(mod, "P"), win.pseudo())

-- Master nav
hl.bind(key(mod, "Return"), dsp.layout("swapwithmaster"))
hl.bind(key(mod, ctrl, "Return"), dsp.layout("focusmaster auto"))
hl.bind(key(mod, ctrl, "comma"), dsp.layout("addmaster"))
hl.bind(key(mod, ctrl, "period"), dsp.layout("removemaster"))
hl.bind(key(mod, ctrl, "TAB"), dsp.layout("orientationnext"))

-- Scroll nav
hl.bind(key(mod, "period"), dsp.layout("move +col"))
hl.bind(key(mod, "comma"), dsp.layout("move -col"))
hl.bind(key(mod, shift, "period"), dsp.layout("swapcol r"))
hl.bind(key(mod, shift, "comma"), dsp.layout("swapcol l"))
hl.bind(key(mod, alt, "Return"), dsp.layout("fit_into_view"))

-- Monocle nav
hl.bind(key(mod, "bracketright"), dsp.layout("cyclenext"))
hl.bind(key(mod, "bracketleft"), dsp.layout("cycleprev"))

-- Focus / resize / move / directional swap (HJKL)
local directions = {
    { "left",  "H", },
    { "down",  "J", },
    { "up",    "K", },
    { "right", "L", },
}

for i = 1, #directions do
    local dir = c.direction[directions[i][1]]
    local k = directions[i][2]
    local axis = c.axis[directions[i][1]]

    hl.bind(key(mod, k), focus({ direction = dir, }))
    hl.bind(key(mod, shift, k),
        win.resize({ x = axis.x, y = axis.y, relative = true, }),
        { repeating = true, })
    hl.bind(key(mod, ctrl, k),
        win.move({ x = axis.x, y = axis.y, relative = true, }),
        { repeating = true, })
    hl.bind(key(mod, ctrl, shift, k), win.swap({ direction = dir, }))
end

-- Swap current window with next / previous window
hl.bind(key(mod, "TAB"), win.swap({ next = true, }))
hl.bind(key(mod, shift, "TAB"), win.swap({ prev = true, }))

-- Dwindle split management
hl.bind(key(mod, ctrl, "S"), dsp.layout("togglesplit"))
hl.bind(key(mod, ctrl, shift, "S"), dsp.layout("swapsplit"))

-- Preselect next split direction
hl.bind(key(mod, ctrl, "left"), dsp.layout("preselect l"))
hl.bind(key(mod, ctrl, "down"), dsp.layout("preselect d"))
hl.bind(key(mod, ctrl, "up"), dsp.layout("preselect u"))
hl.bind(key(mod, ctrl, "right"), dsp.layout("preselect r"))

-- Split ratio
hl.bind(key(mod, ctrl, "minus"), dsp.layout("splitratio -0.1"))
hl.bind(key(mod, ctrl, "equal"), dsp.layout("splitratio +0.1"))
hl.bind(key(mod, ctrl, "R"), dsp.layout("splitratio 1.0 exact"))

-- Fullscreen, Maximize, Float
hl.bind(key(mod, "F"), win.fullscreen({ mode = "fullscreen", }))
hl.bind(key(mod, alt, "F"), win.fullscreen({ mode = "maximized", }))
hl.bind(key(mod, shift, "F"), win.float({ action = "toggle", }))

-- Switch workspaces
for i = 1, 9 do
    local ws = tostring(i)
    hl.bind(key(mod, ws), focus({ workspace = ws, }))
    hl.bind(key(mod, shift, ws), win.move({ workspace = ws, }))
end

hl.bind(key(mod, "0"), focus({ workspace = c.workspace.game, }))
hl.bind(key(mod, shift, "0"), win.move({ workspace = c.workspace.game, }))

-- Special workspace
hl.bind(key(mod, "S"), dsp.workspace.toggle_special(c.workspace.special_name))
hl.bind(key(mod, shift, "S"), win.move({ workspace = c.workspace.special, }))

-- Mouse workspace scroll
hl.bind(key(mod, c.mouse.down), focus({ workspace = "e+1", }))
hl.bind(key(mod, c.mouse.up), focus({ workspace = "e-1", }))

-- Mouse actions
hl.bind(key(mod, c.mouse.middle), win.pin())
hl.bind(key(mod, c.mouse.left), win.drag(), { mouse = true, })
hl.bind(key(mod, c.mouse.right), win.resize(), { mouse = true, })

-- Widget overlays (sina-desktop-widget)
hl.bind(key(mod, "R"), dsp.exec_cmd(app.widget.drun))
hl.bind(key(mod, "N"), dsp.exec_cmd(app.widget.notifications))
hl.bind(key(mod, shift, "N"), dsp.exec_cmd(app.widget.dnd))
hl.bind(key(mod, "V"), dsp.exec_cmd(app.widget.volume))
hl.bind(key(mod, "B"), dsp.exec_cmd(app.widget.bluetooth))
hl.bind(key(mod, "M"), dsp.exec_cmd(app.widget.mpris))
hl.bind(key(mod, "Escape"), dsp.exec_cmd(app.widget.close))
hl.bind(key(mod, ctrl, "M"), dsp.exec_cmd(app.widget.disk))
hl.bind(key(mod, alt, "M"), dsp.exec_cmd(app.widget.menu))

-- Screenshots & utils
hl.bind(key(mod, "print"), acts.screenshot_full())
hl.bind(key(mod, shift, "print"), acts.screenshot_area())
hl.bind(key(mod, alt, "P"), acts.color_picker())

-- Multimedia & TUI apps
hl.bind(key(mod, shift, "M"), dsp.exec_cmd(app.music_player))
hl.bind(key(mod, ctrl, "V"), dsp.exec_cmd(app.volume_manager))
hl.bind(key(mod, alt, "V"), dsp.exec_cmd(app.watch_anime))
hl.bind(key(mod, alt, "L"), dsp.exec_cmd(app.mpd_lyrics))
hl.bind(key(mod, "Z"), dsp.exec_cmd(app.screen_zoom))
