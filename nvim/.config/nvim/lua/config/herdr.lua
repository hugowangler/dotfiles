-- Seamless <C-h/j/k/l> between nvim splits and herdr panes, like
-- vim-tmux-navigator. herdr sends these keys through to nvim (see
-- bin/.local/bin/herdr-navigate); at a split edge nvim hands focus back.
if not vim.env.HERDR_PANE_ID or vim.env.TMUX then
    return
end

local directions = {
    h = "left",
    j = "down",
    k = "up",
    l = "right",
}

for key, direction in pairs(directions) do
    vim.keymap.set("n", "<C-" .. key .. ">", function()
        local win = vim.api.nvim_get_current_win()
        vim.cmd.wincmd(key)
        if vim.api.nvim_get_current_win() == win then
            vim.system({
                "herdr",
                "pane",
                "focus",
                "--pane",
                vim.env.HERDR_PANE_ID,
                "--direction",
                direction,
            }, { detach = true })
        end
    end, { desc = "Navigate " .. direction .. " (herdr-aware)" })
end
