-- lua/rules.lua — Workspace & window rules

local core = require("lua.core")
local c = core.c
local match = core.match

local class = match.class
local titled = match.titled

-- Workspace rules
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0, })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0, })
hl.workspace_rule({ workspace = "5", layout = c.layout.master, })
hl.workspace_rule({ workspace = "6", layout = c.layout.monocle, })
hl.workspace_rule({ workspace = "7", layout = c.layout.scrolling, })

-- Global window rules
hl.window_rule({
    match = { float = false, workspace = "w[tv1]s[false]", },
    border_size = 0,
    rounding = 0,
})
hl.window_rule({
    match = { float = false, workspace = "f[1]s[false]", },
    border_size = 0,
    rounding = 0,
})
hl.window_rule({
    name = "global-suppress-maximize",
    match = class(".*"),
    suppress_event = "maximize",
})

-- Multimedia & Viewers
hl.window_rule({
    name = "imv-rules",
    match = class("^(imv)$"),
    float = true,
    center = true,
    size = {
        900,
        600,
    },
    opacity = 1.0,
})
hl.window_rule({
    name = "mpv-rules",
    match = class("^(mpv)$"),
    float = true,
    center = true,
    max_size = {
        1920,
        1080,
    },
    opacity = 1.0,
})
hl.window_rule({
    name = "telegram-viewer",
    match = titled("^(org%.telegram%.desktop)$", "^(Media viewer)$"),
    float = true,
    max_size = {
        640,
        360,
    },
})

-- Browsers
hl.window_rule({
    name = "firefox-pip",
    match = {
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    size = {
        640,
        360,
    },
    move = {
        6,
        714,
    },
    opacity = 1.0,
})
hl.window_rule({
    name = "firefox-aria2",
    match = titled("^firefox$", "^Extension: %(Aria2 Integration%)"),
    float = true,
    center = true,
    size = {
        360,
        305,
    },
})

-- Gaming
hl.window_rule({
    name = "steam-popups",
    match = titled("^steam.*", "^(Steam Settings|Friends List)$"),
    float = true,
})
hl.window_rule({
    name = "steam-big-picture",
    match = { title = "^Steam Big Picture Mode$", },
    workspace = c.workspace.game,
    fullscreen = true,
    fullscreen_state = c.fullscreen_state.fullscreen,
    tile = true,
})
hl.window_rule({
    name = "steam-game-mode",
    match = class("steam_app_1446780"),
    content = "game",
    fullscreen_state = c.fullscreen_state.fullscreen,
})

-- System Utilities & Tools
hl.window_rule({
    name = "fcitx5-pseudo",
    match = class("^fcitx5$"),
    pseudo = true,
})
hl.window_rule({
    name = "thunar-progress",
    match = titled("^(thunar)$", "^(File Operation Progress)$"),
    float = true,
})
hl.window_rule({
    name = "file-roller",
    match = class("^(org%.gnome%.FileRoller)$"),
    float = true,
})
hl.window_rule({
    name = "qalculate-qt",
    match = class("^(io%.github%.Qalculate%.qalculate-qt)$"),
    float = true,
    size = {
        640,
        360,
    },
})
hl.window_rule({
    name = "qalculate-gtk",
    match = class("^(qalculate-gtk)$"),
    float = true,
    size = {
        640,
        360,
    },
})
hl.window_rule({
    name = "usbimager-float",
    match = class("^(USBImager 1%.0%.10)$"),
    float = true,
})
hl.window_rule({
    name = "rquickshare",
    match = class("^([Rr]quickshare|R%-quick%-share)$"),
    float = true,
})

-- Floating TUI / Custom Scripts
hl.window_rule({
    name = "ncmpcpp-keybind",
    match = class("^(ncmpcpp-float-key)$"),
    float = true,
    size = {
        1120,
        480,
    },
})
hl.window_rule({
    name = "sptlrx-keybind",
    match = class("^(mpd_lyrics)$"),
    float = true,
    size = {
        380,
        1053,
    },
    move = {
        1539,
        25,
    },
})
hl.window_rule({
    name = "alsamixer-keybind",
    match = class("^(alsamixer-float)$"),
    float = true,
    size = {
        111,
        320,
    },
    move = {
        3,
        29,
    },
})
hl.window_rule({
    name = "ani-cli-keybind",
    match = class("^(ani-cli-float)$"),
    float = true,
    size = {
        476,
        155,
    },
    move = {
        728,
        28,
    },
})
hl.window_rule({
    name = "udisktui-rules",
    match = class("^(udiskstui)$"),
    float = true,
    center = true,
    size = {
        1000,
        300,
    },
})
hl.window_rule({
    name = "hyprpwcenter",
    match = titled("hyprpwcenter", "Pipewire Control Center"),
    float = true,
    center = true,
    max_size = {
        1366,
        600,
    },
    no_anim = true,
})

-- Academic / Work
hl.window_rule({
    name = "zoom-stayfocused",
    match = {
        class = "zoom",
        initial_title = "menu window|meeting bottombar popup|sub menu window",
    },
    stay_focused = true,
})
hl.window_rule({
    name = "zoom-float",
    match = {
        class = "zoom",
        initial_title = "menu window|Meeting|Meeting chat",
    },
    float = true,
})
hl.window_rule({
    name = "zotero-float",
    match = titled("^(Zotero)$",
        "^(Quick Format Citation|Citation Dialog|Citation Picker|Progress)$"),
    float = true,
    center = true,
    no_anim = true,
})
hl.window_rule({
    name = "zotero-maxsize",
    match = titled("^(Zotero)$",
        "^(Quick Format Citation|Citation Dialog|Citation Picker)$"),
    max_size = {
        800,
        600,
    },
})

-- Torrent
hl.window_rule({
    name = "qbittorrent-add-torrent-dialog",
    match = {
        class = [[^org\.qbittorrent\.qBittorrent$]],
        title = [[negative:^qBittorrent v.*]],
    },
    float = true,
    size = { 957, 768, },
    center = true,
})

-- GIMP Dialogs
local gimp_dialogs = { "Open Image as Layers", "Open Image", "Export Image", }
for _, dialog in ipairs(gimp_dialogs) do
    hl.window_rule({
        name   = "gimp-" .. dialog:lower():gsub(" ", "-"),
        match  = { title = "^(" .. dialog .. ")$", },
        size   = { 800, 600, },
        center = true,
    })
end
