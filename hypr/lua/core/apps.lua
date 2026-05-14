local path = require("lua.core.paths")

local terminal = "footclient"

local function foot_app(app_id, command)
    return string.format("%s --app-id='%s' %s", terminal, app_id, command)
end

return {
    terminal        = terminal,
    file_manager    = "thunar",
    menu            = "wofi --show drun --allow-images",
    web_browser     = "firefox-bin",
    web_browser_prv = "firefox-bin -private-window",
    volume_manager  = "hyprpwcenter",

    music_player    = foot_app("ncmpcpp-float-key", "ncmpcpp"),
    volume_mixer    = foot_app("alsamixer-float", "alsamixer"),
    watch_anime     = foot_app("ani-cli-float", "ani-cli"),
    udiskstui       = foot_app("udiskstui", path.bin.cargo .. "/udiskstui"),
    mpd_lyrics      = foot_app("mpd_lyrics",
        path.bin.local_bin .. "/sptlrx -p mpd"),

    screen_zoom     = path.file.hypr_zoom .. " -easing=InOutCubic -interp=Linear",
}
