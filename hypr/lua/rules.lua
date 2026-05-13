-- ============================================================
--  lua/rules.lua — Workspace & Window Management Rules
-- ============================================================

local w_rule  = hl.window_rule
local ws_rule = hl.workspace_rule

-- Workspace Rules
ws_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
ws_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })

-- Per-workspace layouts
ws_rule({ workspace = "5", layout = "master" })
ws_rule({ workspace = "6", layout = "monocle" })
ws_rule({ workspace = "7", layout = "scrolling" })

-- Global Window Rules
w_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0, rounding = 0 })
w_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0, rounding = 0 })
w_rule({ name = "global-suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- Multimedia & Viewers
w_rule({ name = "imv-rules", match = { class = "^(imv)$" }, float = true, center = true, size = { 900, 600 }, opacity = 1.0 })
w_rule({ name = "mpv-rules", match = { class = "^(mpv)$" }, float = true, center = true, max_size = { 1920, 1080 }, opacity = 1.0 })
w_rule({ name = "telegram-viewer", match = { class = "^(org%.telegram%.desktop)$", title = "^(Media viewer)$" }, float = true, max_size = { 640, 360 } })

-- Browsers
w_rule({ name = "firefox-pip", match = { title = "^(Picture-in-Picture)$" }, float = true, size = { 640, 360 }, move = { 6, 714 }, opacity = 1.0 })
w_rule({ name = "firefox-aria2", match = { class = "^firefox$", title = "^Extension: %(Aria2 Integration%)" }, float = true, center = true, size = { 360, 305 } })

-- Gaming
w_rule({ name = "steam-popups", match = { class = "^steam.*", title = "^(Steam Settings|Friends List)$" }, float = true })
w_rule({ name = "paradox-launcher", match = { class = "^Paradox Launcher$", title = "^Europa Universalis IV$" }, float = true })
w_rule({
    name = "steam-big-picture",
    match = { title = "^Steam Big Picture Mode$" },
    workspace = "10",
    fullscreen = true,
    fullscreen_state =
    "3 3",
    tile = true
})
w_rule({ name = "steam-game-mode", match = { class = "steam_app_1446780" }, content = "game", fullscreen_state = "3 3" })

-- System Utilities & Tools
w_rule({ name = "fcitx5-pseudo", match = { class = "^fcitx5$" }, pseudo = true })
w_rule({ name = "thunar-progress", match = { class = "^(thunar)$", title = "^(File Operation Progress)$" }, float = true })
w_rule({ name = "file-roller", match = { class = "^(org%.gnome%.FileRoller)$" }, float = true })
w_rule({ name = "qalculate-qt", match = { class = "^(io%.github%.Qalculate%.qalculate-qt)$" }, float = true, size = { 640, 360 } })
w_rule({ name = "qalculate-gtk", match = { class = "^(qalculate-gtk)$" }, float = true, size = { 640, 360 } })
w_rule({ name = "usbimager-float", match = { class = "^(USBImager 1%.0%.10)$" }, float = true })
w_rule({ name = "rquickshare", match = { class = "^([Rr]quickshare|R%-quick%-share)$" }, float = true })

-- Floating TUI / Custom Scripts
w_rule({ name = "ncmpcpp-keybind", match = { class = "^(ncmpcpp-float-key)$" }, float = true, size = { 1120, 480 } })
w_rule({ name = "sptlrx-keybind", match = { class = "^(mpd_lyrics)$" }, float = true, size = { 380, 1053 }, move = { 1539, 25 } })
w_rule({ name = "alsamixer-keybind", match = { class = "^(alsamixer-float)$" }, float = true, size = { 111, 320 }, move = { 3, 29 } })
w_rule({ name = "ani-cli-keybind", match = { class = "^(ani-cli-float)$" }, float = true, size = { 476, 155 }, move = { 728, 28 } })
w_rule({ name = "udisktui-rules", match = { class = "^(udiskstui)$" }, float = true, center = true, size = { 1000, 300 } })
w_rule({ name = "hyprpwcenter", match = { class = "hyprpwcenter", title = "Pipewire Control Center" }, float = true, center = true, max_size = { 1366, 600 }, no_anim = true })

-- Academic / Work
w_rule({ name = "zoom-stayfocused", match = { class = "zoom", initial_title = "menu window|meeting bottombar popup|sub menu window" }, stay_focused = true })
w_rule({ name = "zoom-float", match = { class = "zoom", initial_title = "menu window|Meeting|Meeting chat" }, float = true })
w_rule({ name = "zotero-float", match = { class = "^(Zotero)$", title = "^(Quick Format Citation|Citation Dialog|Citation Picker|Progress)$" }, float = true, center = true, no_anim = true })
w_rule({ name = "zotero-maxsize", match = { class = "^(Zotero)$", title = "^(Quick Format Citation|Citation Dialog|Citation Picker)$" }, max_size = { 800, 600 } })

-- GIMP Dialogs
local gimp_dialogs = { "Open Image as Layers", "Open Image", "Export Image" }
for _, dialog in ipairs(gimp_dialogs) do
    w_rule({
        name   = "gimp-" .. dialog:lower():gsub(" ", "-"),
        match  = { title = "^(" .. dialog .. ")$" },
        size   = { 800, 600 },
        center = true,
    })
end
