return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
        "fredrikaverpil/neotest-golang",
    },
    keys = {
        { "<leader>tn", function() require("neotest").run.run() end, desc = "Test nearest" },
        { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
        { "<leader>ts", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test suite" },
        { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test last" },
        { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
        { "<leader>tt", function() require("neotest").summary.toggle() end, desc = "Test summary" },
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
