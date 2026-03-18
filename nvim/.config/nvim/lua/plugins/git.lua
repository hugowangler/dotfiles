return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                on_attach = function(bufnr)
                    local gs = require("gitsigns")
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")
                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
                    map("n", "[h", function() gs.nav_hunk("prev") end, "Previous hunk")
                end,
            })
        end,
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
        keys = {
            { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
        },
    },
}
