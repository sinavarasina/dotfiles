return {
  {
    "tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "4513ECHO/vim-colors-hatsunemiku",
  },
  {
    "doki-theme/doki-theme-vim",
  },
  {
    "Spelis/nvim-dbview",
    opts = {
      python_path = "python",
      exec_key = "<C-x>",
    },
    -- Lazy load if you want. no guarantee it will work.
  },
}
