-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

--- ts 4 by default; autocommand sets it to 2 for lua
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.swapfile = false -- more annoying than helpful
vim.opt.title = true -- update titlebar with doc path- Add any additional options here

-- go templ template system
-- https://templ.guide/commands-and-tools/ide-support/
vim.filetype.add({ extension = { templ = "templ" } })
