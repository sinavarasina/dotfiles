-- lua/rules/torrent.lua — Torrent client rules

hl.window_rule({
    name = "qbittorrent-add-torrent-dialog",
    match = {
        class = [[^org\.qbittorrent\.qBittorrent$]],
        title = [[negative:^qBittorrent v.*]],
    },
    float = true,
    size = "monitor_w*0.5 monitor_h*0.71",
    center = true,
})
