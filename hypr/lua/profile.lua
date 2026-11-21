return {
    env = {
        "editor",
        "wayland",
        "qt",
        "xdg",
        "firefox",
        "electron",
        "cursor",
        "terminal",
        "mpd",
        "mangohud",
        "amd",
        "hdr",
        "fcitx",

        -- Disabled env modules:
        -- "nvidia",
        -- "vm",
    },

    monitors = {
        "mi-g24i",
        "fallback",
    },

    rules = {
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
    },

    extra = {
        -- "lua.extra.automount",
        "lua.extra.portal_workaround",
    },
}
