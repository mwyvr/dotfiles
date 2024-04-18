return {
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			mappings = {
				["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
			},
		},
		keys = {
			{
				"<leader>up",
				function()
					vim.g.minipairs_disable = not vim.g.minipairs_disable
					if vim.g.minipairs_disable then
						LazyVim.warn("Disabled auto pairs", { title = "Option" })
					else
						LazyVim.info("Enabled auto pairs", { title = "Option" })
					end
				end,
				desc = "Toggle Auto Pairs",
			},
		},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
		},
	},
}
