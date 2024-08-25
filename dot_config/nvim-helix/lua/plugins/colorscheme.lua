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
}
