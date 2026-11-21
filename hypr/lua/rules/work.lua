-- lua/rules/work.lua — Academic and work app rules

local core = require("lua.core")
local match = core.match
local titled = match.titled

local zoom_class = "^(zoom|Zoom Workplace)$"

hl.window_rule({
    name = "zoom-dialogs-float",
    match = titled(zoom_class,
        "negative:^(Zoom Workplace.*|Zoom Meeting|Zoom Cloud Meetings)$"),
    float = true,
})

hl.window_rule({
    name = "zoom-menus",
    match = {
        class = zoom_class,
        initial_title = "^(|zoom|menu window|sub menu window|meeting bottombar popup)$",
    },
    float = true,
    stay_focused = true,
    no_blur = true,
    no_shadow = true,
    no_anim = true,
    border_size = 0,
})

hl.window_rule({
    name = "zoom-share-toolbar",
    match = titled(zoom_class, "^(as_toolbar)$"),
    float = true,
    pin = true,
    no_blur = true,
    no_shadow = true,
    no_anim = true,
    border_size = 0,
})

hl.window_rule({
    name = "zoom-meeting-inhibit-idle",
    match = titled(zoom_class, "^(Zoom Meeting)$"),
    idle_inhibit = "always",
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
