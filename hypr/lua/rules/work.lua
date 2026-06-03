-- lua/rules/work.lua — Academic and work app rules

local match = require("lua.core.match")
local titled = match.titled

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
