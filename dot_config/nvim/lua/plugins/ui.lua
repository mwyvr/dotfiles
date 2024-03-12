return {
  -- nightfox scheme which provides nordfox etc
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true, -- dotfiles/wallpaper/darkblue-left.jpg
          styles = {
            comments = "italic",
            -- keywords = "bold",
            -- types = "italic,bold",
          },
        },
        palettes = {
          nordfox = {
            bg1 = "#20242c", -- #2e3440 is the original
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

  -- complains due to transparency ^
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#1a1d23",
      -- default causes too many popups, making it easy to end up with focus
      -- in the notify window itself, so dial it back to more important notices
      level = vim.log.levels.WARN,
      timeout = 500,
    },
  },

  -- highlight colour names, rgb and other values with colour
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true, -- also tailwind colours
      },
    },
  },

  -- scheme:
  {
    "LazyVim/LazyVim",
    opts = {
      -- do it the LazyVim way
      colorscheme = "nordfox",
    },
  },

  -- not a fan of the indent animation
  {
    "echasnovski/mini.indentscope",
    enabled = false,
  },
}
