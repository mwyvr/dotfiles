-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- default for other types is 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- run `chezmoi apply` on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "~/.local/share/chezmoi/*" },
  command = 'chezmoi apply --source-path "%"',
})
