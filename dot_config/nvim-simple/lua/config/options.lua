-- overrides to core + options not specific to a plugin

-- used on config/autocmds.lua:
vim.g.format_on_save = { "*.go", "*.py", "*.sh", "*.css", "*.lua", "*.templ", "*.html" }

-- option overrides
vim.opt.relativenumber = true -- set true if you use motions frequently
vim.opt.swapfile = false -- more annoying than helpful
-- tabs
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.expandtab = true -- replaces tabs with spaces
--
vim.opt.title = true -- update titlebar with doc path

