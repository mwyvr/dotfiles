-- return {
-- 	{"folke/which-key.nvim",
-- 	dependencies = { 'echasnovski/mini.icons', version = false },
-- 	event = "VeryLazy",
-- 	opts = {
-- 		plugins = { spelling = true },
-- 		defaults = {
-- 			mode = { "n", "v" },
-- 			-- ["g"] = { name = "+goto" },
-- 			-- ["gs"] = { name = "+surround" },
-- 			["z"] = { name = "+fold" },
-- 			["]"] = { name = "+next" },
-- 			["["] = { name = "+prev" },
-- 			["<leader><tab>"] = { name = "+tabs" },
-- 			["<leader>b"] = { name = "+buffer" },
-- 			["<leader>c"] = { name = "+code" },
-- 			["<leader>f"] = { name = "+file/find" },
-- 			-- ["<leader>g"] = { name = "+git" },
-- 			-- ["<leader>gh"] = { name = "+hunks" },
-- 			["<leader>q"] = { name = "+quit/session" },
-- 			["<leader>s"] = { name = "+search" },
-- 			["<leader>u"] = { name = "+ui" },
-- 			["<leader>w"] = { name = "+windows" },
-- 			["<leader>x"] = { name = "+diagnostics/quickfix" },
-- 		},
-- 	},
-- 	config = function(_, opts)
-- 		local wk = require("which-key")
-- 		wk.setup(opts)
-- 		wk.register(opts.defaults)
-- 	end,
-- 	init = function()
-- 		vim.o.timeout = true
-- 		vim.o.timeoutlen = 200
-- 	end,
-- },
-- }
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    defaults = {}, -- don't use, deprecated
    preset = "helix",
    sort = {"manual",},
    spec = {
      {
        mode = { "n", "v" },
        -- arranged in same order as Helix
        { "<leader>f", group = "Open file picker" },
        {
          "<leader>b",
          group = "Open buffer picker",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },

        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps (which-key)",
    },
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    if not vim.tbl_isempty(opts.defaults) then
      LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
      wk.register(opts.defaults)
    end
  end,
}
