return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "fredrikaverpil/neotest-golang",
    },
    keys = {
        { "t<C-n>", function() require("neotest").run.run() end, desc = "Test nearest" },
        { "t<C-f>", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
        { "t<C-s>", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test suite" },
        { "t<C-l>", function() require("neotest").run.run_last() end, desc = "Test last" },
        { "t<C-o>", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
        { "t<C-t>", function() require("neotest").summary.toggle() end, desc = "Test summary" },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python")({
                    dap = { justMyCode = false },
                    runner = "pytest",
                }),
                require("neotest-golang")(),
            },
        })
    end,
}
