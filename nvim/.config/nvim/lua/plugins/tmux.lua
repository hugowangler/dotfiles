return {
    "christoomey/vim-tmux-navigator",
    -- Inside herdr, config/herdr.lua owns <C-h/j/k/l> instead.
    cond = vim.env.TMUX ~= nil,
    event = "VeryLazy",
}
