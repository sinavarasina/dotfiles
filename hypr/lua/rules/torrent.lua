-- lua/rules/torrent.lua — Torrent client rules

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
