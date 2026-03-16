local map = vim.keymap.set

-- Clear search highlight with enter
map("n", "<CR>", "<cmd>noh<CR><CR>", { silent = true })

-- Disable command-line window (too easy to mispress instead of :q)
map("n", "q:", "<nop>", { desc = "Disable command-line window" })

-- Reload config
map("n", "<leader>R", "<cmd>source $MYVIMRC<CR>", { desc = "Reload config" })

-- Resize splits
map("n", "<C-w>H", "<C-w>5<", { desc = "Resize left" })
map("n", "<C-w>L", "<C-w>5>", { desc = "Resize right" })
map("n", "<C-w>J", "<C-w>5+", { desc = "Resize down" })
map("n", "<C-w>K", "<C-w>5-", { desc = "Resize up" })
