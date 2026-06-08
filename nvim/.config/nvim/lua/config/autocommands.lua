-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({ timeout = 200, visual = true })
    end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_comment", {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Dim the active split's background when the whole nvim instance loses
-- tmux/terminal focus. tokyonight's dim_inactive only dims NON-current windows
-- (NormalNC); the active split keeps Normal.bg and still looks focused even
-- when its tmux pane is not. Restore on focus regain. cursorline left as-is.
--
-- The dim target is read live from NormalNC (what dim_inactive already applies
-- to inactive splits), so it tracks the active colorscheme without hardcoding.
local focus_dim = vim.api.nvim_create_augroup("focus_dim", { clear = true })

-- Snapshot the focused/dim backgrounds whenever the colorscheme (re)loads,
-- before we start mutating Normal. Reading Normal live would be self-referential
-- once dimmed, so capture it here instead. fg is preserved on every set.
local active_bg, dim_bg

local function snapshot_bgs()
    active_bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    dim_bg = vim.api.nvim_get_hl(0, { name = "NormalNC", link = false }).bg
end

local function set_normal_bg(focused)
    if not active_bg then
        snapshot_bgs()
    end
    local fg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg
    vim.api.nvim_set_hl(0, "Normal", { fg = fg, bg = focused and active_bg or dim_bg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = focus_dim,
    callback = snapshot_bgs,
})
vim.api.nvim_create_autocmd("FocusLost", {
    group = focus_dim,
    callback = function()
        set_normal_bg(false)
    end,
})
vim.api.nvim_create_autocmd("FocusGained", {
    group = focus_dim,
    callback = function()
        set_normal_bg(true)
    end,
})
