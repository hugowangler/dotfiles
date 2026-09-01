return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    },
    opts = {
        image = {},
        indent = {
            animate = {
                enabled = false,
            },
            scope = {
                enabled = false,
            },
        },
        lazygit = {},
    }
}
