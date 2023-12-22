-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Normal: shift H/L also moves to previous/next tab but habits die hard
vim.keymap.set("n", "<tab>", "<cmd>:bn<cr>", { desc = "Buffer Next" })
vim.keymap.set("n", "<s-tab>", "<cmd>:bp<cr>", { desc = "Buffer Previous" })
