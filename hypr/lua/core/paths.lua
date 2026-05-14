local home = assert(os.getenv("HOME"), "HOME is not set")

return {
    home = home,

    bin = {
        cargo     = home .. "/.cargo/bin",
        local_bin = home .. "/.local/bin",
    },

    dir = {
        screenshots = home .. "/Pictures/Screenshots",
        dotfiles    = home .. "/dotfiles",
    },

    file = {
        wallpaper = home .. "/dotfiles/wallpapers/Yuki-Gentoo-wallpaper-r2.png",
        icc       = home .. "/dotfiles/ColorProfile/G24i-lordkutang.icm",
        hypr_zoom = home .. "/Applications/hypr-zoom",
    },
}
