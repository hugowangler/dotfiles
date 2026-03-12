local map = vim.keymap.set

-- Clear search highlight with enter
map("n", "<CR>", "<cmd>noh<CR><CR>", { silent = true })

-- Disable command-line window (too easy to mispress instead of :q)
map("n", "q:", "<nop>", { desc = "Disable command-line window" })

