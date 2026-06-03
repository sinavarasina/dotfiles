local home = assert(os.getenv("HOME"), "HOME is not set")
local dotfiles = home .. "/dotfiles"

return {
    home = home,

    bin = {
        cargo     = home .. "/.cargo/bin",
        local_bin = home .. "/.local/bin",
    },

    dir = {
        screenshots = home .. "/Pictures/Screenshots",
        dotfiles    = dotfiles,
    },

    file = {
        wallpaper = dotfiles .. "/wallpapers/Yuki-Gentoo-wallpaper-r2.png",
        hypr_zoom = home .. "/Applications/hypr-zoom",
    },
}
