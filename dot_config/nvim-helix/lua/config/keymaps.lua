-- buffers
vim.keymap.set("n", "<tab>", "<cmd>:bn<cr>", { desc = "Buffer Next" })
vim.keymap.set("n", "<s-tab>", "<cmd>:bp<cr>", { desc = "Buffer Previous" })

-- building on persistence.nvim maps:
vim.keymap.set("n", "<leader>qq", "<cmd>:qa<cr>", { desc = "Quit All" })

-- plugins
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazyvim" })

local ts = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", ts.find_files, { desc = "Open File Picker" })
vim.keymap.set("n", "<leader>b", ts.buffers, { desc = "Open Buffer Picker" })
vim.keymap.set("n", "<leader>o", ts.oldfiles, { desc = "Open Old/Recent Files" })
vim.keymap.set("n", "<leader>/", ts.live_grep, { desc = "Global search" })
vim.keymap.set("n", "<leader>w", "<cmd>:w<cr>", { desc = "Write file" })

-- search
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

-- git
vim.keymap.set("n", "<leader>w", "<cmd>:w<cr>", { desc = "Write file" })

