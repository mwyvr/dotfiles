-- Managed by chezmoi dotfile manager, see - https://github.com/mwyvr/dotfiles

-- bootstrap lazy.nvim plugin manager
vim.g.mapleader = " " -- should be defined before Lazy.nvim loaded
vim.g.maplocalleader = "\\"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins") -- plugins and their configs
require("config") -- options, keybindings, autocmds
