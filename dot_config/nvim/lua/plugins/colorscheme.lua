return {
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
          styles = {
            comments = "italic",
            -- keywords = "bold",
            -- types = "italic,bold",
          },
        },
        palettes = {
          nordfox = {
            bg1 = "#16191f", -- darker; #2e3440 is the original
          },
        },
        groups = {
          nordfox = {
            CursorLine = { bg = "#101216" }, -- darker than bg, works with non-trans bg
          },
        },
      })
    end,
  },
  -- load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nordfox",
    },
  },
}
