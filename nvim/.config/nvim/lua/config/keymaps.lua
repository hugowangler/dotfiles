local map = vim.keymap.set

-- Clear search highlight with enter
map("n", "<CR>", "<cmd>noh<CR><CR>", { silent = true })

