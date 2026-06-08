return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            dim_inactive = true,
            on_highlights = function(hl, c)
                hl.WinSeparator = { fg = c.fg_gutter }
            end,
        })
        vim.cmd.colorscheme("tokyonight-night")
    end,
}
