-- ============================================================
--  lua/globals.lua — Variables & App References
-- ============================================================

local home = os.getenv("HOME")

_G.V = {
    terminal        = "footclient",
    file_manager    = "thunar",
    menu            = "wofi --show drun --allow-images",
    web_browser     = "firefox-bin",
    web_browser_prv = "firefox-bin -private-window",

    music_player    = "footclient --app-id='ncmpcpp-float-key' ncmpcpp",
    volume_mixer    = "footclient --app-id='alsamixer-float' alsamixer",
    watch_anime     = "footclient --app-id='ani-cli-float' ani-cli",
    udiskstui       = "footclient --app-id='udiskstui' " .. home .. "/.cargo/bin/udiskstui",
    mpd_lyrics      = "footclient --app-id='mpd_lyrics' " .. home .. "/.local/bin/sptlrx -p mpd",
    screen_zoom     = home .. "/Applications/hypr-zoom -easing=InOutCubic -interp=Linear",
    wallpaper       = home .. "/dotfiles/wallpapers/Yuki-Gentoo-wallpaper-r2.png",
}
