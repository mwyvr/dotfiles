return {
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = false,
          styles = {
            comments = "italic",
            -- keywords = "bold",
            -- types = "italic,bold",
          },
        },
        palettes = {
          nordfox = {
            bg1 = "#20242c", -- darker; #2e3440 is the original
          },
        },
        groups = {
          nordfox = {
            CursorLine = { bg = "#1a1d23" }, -- 10% darker than bg, works with non-trans bg
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
