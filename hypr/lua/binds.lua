-- ============================================================
--  lua/binds.lua — All Keybindings
-- ============================================================

local acts = require("lua.actions")
local M    = "SUPER"

-- API Aliasing
local function exec(cmd) return hl.dsp.exec_cmd(cmd) end
local layout    = hl.dsp.layout
local focus     = hl.dsp.focus
local window    = hl.dsp.window
local workspace = hl.dsp.workspace

-- Core apps
hl.bind(M .. " + Q", exec(V.terminal))
hl.bind(M .. " + C", window.close())
hl.bind(M .. " + SHIFT + C", acts.kill_active())
hl.bind(M .. " + ALT + F4", hl.dsp.exit())
hl.bind(M .. " + E", exec(V.file_manager))
hl.bind(M .. " + R", exec(V.menu))
hl.bind(M .. " + W", exec(V.web_browser))
hl.bind(M .. " + SHIFT + W", exec(V.web_browser_prv))

-- Layout switch
hl.bind(M .. " + ALT + D", exec("hyprctl keyword general:layout dwindle"))
hl.bind(M .. " + ALT + M", exec("hyprctl keyword general:layout master"))
hl.bind(M .. " + ALT + O", exec("hyprctl keyword general:layout monocle"))
hl.bind(M .. " + ALT + S", exec("hyprctl keyword general:layout scrolling"))
hl.bind(M .. " + P", window.pseudo())

-- Master nav
hl.bind(M .. " + Return", layout("swapwithmaster"))
hl.bind(M .. " + CTRL + Return", layout("focusmaster auto"))
hl.bind(M .. " + CTRL + comma", layout("addmaster"))
hl.bind(M .. " + CTRL + period", layout("removemaster"))
hl.bind(M .. " + CTRL + TAB", layout("orientationnext"))

-- Scroll nav
hl.bind(M .. " + period", layout("move +col"))
hl.bind(M .. " + comma", layout("move -col"))
hl.bind(M .. " + SHIFT + period", layout("swapcol r"))
hl.bind(M .. " + SHIFT + comma", layout("swapcol l"))

-- Monocle nav
hl.bind(M .. " + bracketright", layout("cyclenext"))
hl.bind(M .. " + bracketleft", layout("cycleprev"))

-- Move focus (Vim style)
hl.bind(M .. " + H", focus({ direction = "l" }))
hl.bind(M .. " + J", focus({ direction = "d" }))
hl.bind(M .. " + K", focus({ direction = "u" }))
hl.bind(M .. " + L", focus({ direction = "r" }))

-- Swapping window
hl.bind(M .. " + TAB", layout("swapnext"))
hl.bind(M .. " + SHIFT + TAB", layout("swapnext prev"))

-- Fullscreen, Maximize, Float
hl.bind(M .. " + F", window.fullscreen({ mode = "fullscreen" }))
hl.bind(M .. " + ALT + F", window.fullscreen({ mode = "maximized" }))
hl.bind(M .. " + SHIFT + F", window.float({ action = "toggle" }))

-- Resize window
hl.bind(M .. " + SHIFT + H", window.resize({ x = -5, y = 0, relative = true }), { repeating = true })
hl.bind(M .. " + SHIFT + L", window.resize({ x = 5, y = 0, relative = true }), { repeating = true })
hl.bind(M .. " + SHIFT + K", window.resize({ x = 0, y = -5, relative = true }), { repeating = true })
hl.bind(M .. " + SHIFT + J", window.resize({ x = 0, y = 5, relative = true }), { repeating = true })

-- Move floating window
hl.bind(M .. " + CTRL + H", window.move({ x = -5, y = 0, relative = true }), { repeating = true })
hl.bind(M .. " + CTRL + L", window.move({ x = 5, y = 0, relative = true }), { repeating = true })
hl.bind(M .. " + CTRL + K", window.move({ x = 0, y = -5, relative = true }), { repeating = true })
hl.bind(M .. " + CTRL + J", window.move({ x = 0, y = 5, relative = true }), { repeating = true })

-- Switch workspaces
for i = 1, 9 do
    local k = tostring(i)
    hl.bind(M .. " + " .. k, focus({ workspace = k }))
    hl.bind(M .. " + SHIFT + " .. k, window.move({ workspace = k }))
end
hl.bind(M .. " + 0", focus({ workspace = "10" }))
hl.bind(M .. " + SHIFT + 0", window.move({ workspace = "10" }))

-- Special workspace
hl.bind(M .. " + S", workspace.toggle_special("magic"))
hl.bind(M .. " + SHIFT + S", window.move({ workspace = "special:magic" }))

-- Mouse workspace scroll
hl.bind(M .. " + mouse_down", focus({ workspace = "e+1" }))
hl.bind(M .. " + mouse_up", focus({ workspace = "e-1" }))

-- Mouse actions
hl.bind(M .. " + mouse:274", window.pin())
hl.bind(M .. " + mouse:272", window.drag(), { mouse = true })
hl.bind(M .. " + mouse:273", window.resize(), { mouse = true })

-- UI toggles
hl.bind(M .. " + ALT + B", exec("killall -SIGUSR1 waybar"))

-- Screenshots & utils
hl.bind(M .. " + print", acts.screenshot_full())
hl.bind(M .. " + SHIFT + print", acts.screenshot_area())

-- Multimedia & TUI apps
hl.bind(M .. " + SHIFT + M", exec(V.music_player))
hl.bind(M .. " + CTRL + V", exec("hyprpwcenter"))
hl.bind(M .. " + ALT + V", exec(V.watch_anime))
hl.bind(M .. " + CTRL + M", exec(V.udiskstui))
hl.bind(M .. " + ALT + L", exec(V.mpd_lyrics))
hl.bind(M .. " + Z", exec(V.screen_zoom))
