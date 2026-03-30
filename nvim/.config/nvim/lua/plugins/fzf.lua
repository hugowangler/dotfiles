return {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    keys = {
        { "<C-p>",      function() require("fzf-lua").files() end,     desc = "Find files" },
        { "<leader>ff", function() require("fzf-lua").files() end,     desc = "Find files" },
        { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
        { "<leader>fb", function() require("fzf-lua").buffers() end,   desc = "Buffers" },
        { "<leader>/",  function() require("fzf-lua").blines() end,    desc = "Buffer lines" },
        { "<leader>fh", function() require("fzf-lua").oldfiles() end,  desc = "Recent files" },
        { "<leader>fF", function() require("fzf-lua").files({ no_ignore = true }) end, desc = "Find files (no gitignore)" },
    },
    opts = {},
}
