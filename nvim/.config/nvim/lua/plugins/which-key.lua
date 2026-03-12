return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.add({
            { "<leader>f", group = "find" },
            { "<leader>h", group = "git hunk" },
            { "<leader>q", group = "quickfix" },
            { "<leader>t", group = "test" },
            { "<leader>o", group = "opencode" },
            { "<leader>u", group = "toggle" },
        })
    end,
}
