return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            theme = "auto",
            globalstatus = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch",
                {
                    "diff"
                },
            },
            lualine_c = { "filename" },
            lualine_x = { "diagnostics", "filetype" },
            lualine_y = {},
            lualine_z = { { "location", separator = { right = "" } } },
        },
        extensions = { "nvim-tree", "fzf", "lazy", "mason", "fugitive", "quickfix" },
    },
}
