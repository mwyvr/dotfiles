return {
	{
		"EdenEast/nightfox.nvim",
		config = function()
			require("nightfox").setup({
				options = {
					transparent = false, -- dotfiles/wallpaper/darkblue-left.jpg
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
			-- vim.cmd.colorscheme("nordfox")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			integrations = {
				aerial = true,
				alpha = true,
				cmp = true,
				dashboard = true,
				flash = true,
				gitsigns = true,
				headlines = true,
				illuminate = true,
				indent_blankline = { enabled = true },
				leap = true,
				lsp_trouble = true,
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				navic = { enabled = true, custom_bg = "lualine" },
				neotest = true,
				neotree = true,
				noice = true,
				notify = true,
				semantic_tokens = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
		-- config = function()
		-- 	vim.cmd.colorscheme("catppuccin-mocha")
		-- end,
	},
}
