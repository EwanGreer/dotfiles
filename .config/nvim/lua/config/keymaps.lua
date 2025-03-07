-- Keymaps are automatically loaded on the VeryLazy event
-- Add any additional keymaps here

-- Neotree
vim.keymap.set("n", "<leader>o", "<cmd>Neotree filesystem focus right<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle right<cr>")

-- Oil
vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })

-- LazyGit
vim.keymap.set("n", "<leader>gg", "<CMD>LazyGit<CR>")
