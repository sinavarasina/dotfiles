-- lua/rules/init.lua — Window rule module loader

local module = require("lua.core.module")

module.load_named("lua.rules", {
    "workspace",
    "global",
    "media",
    "browser",
    "gaming",
    "system",
    "tui",
    "work",
    "torrent",
    "gimp",
})
