return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"go",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"templ",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},

			config = function()
				local config = require("nvim-treesitter.configs")
				config.setup({
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
					opts = opts,
				})
			end,
		},
	},
}
