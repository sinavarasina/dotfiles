-- lua/rules/gimp.lua — GIMP dialog rules

local core = require("lua.core")
local match = core.match
local titled = match.titled

local gimp_class = "^([Gg]imp.*|org%.gimp%.GIMP)$"
local gimp_dialogs = { "Open Image as Layers", "Open Image", "Export Image", }

for i = 1, #gimp_dialogs do
    local dialog = gimp_dialogs[i]

    hl.window_rule({
        name   = "gimp-" .. dialog:lower():gsub(" ", "-"),
        match  = titled(gimp_class, "^(" .. dialog .. ")$"),
        size   = { 800, 600, },
        center = true,
    })
end
