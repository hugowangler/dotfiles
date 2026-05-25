return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.setup()
        wk.add({
            { "<leader>f", group = "find" },
            { "<leader>g", group = "git" },
            { "<leader>h", group = "git hunk" },
            { "<leader>q", group = "quickfix" },
            { "<leader>r", group = "run" },
            { "<leader>t", group = "test" },
            { "<leader>o", group = "opencode" },
            { "<leader>u", group = "toggle" },
            { "<leader>ua", desc = "Toggle ty call argument hints" },
            { "<leader>uh", desc = "Toggle inlay hints" },
            { "<leader>uv", desc = "Toggle ty variable type hints" },
        })
    end,
}
