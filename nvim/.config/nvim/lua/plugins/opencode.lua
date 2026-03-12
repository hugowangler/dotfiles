return {
    "sudo-tee/opencode.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            opts = {
                anti_conceal = { enabled = false },
                file_types = { "markdown", "opencode_output" },
            },
            ft = { "markdown", "opencode_output" },
        },
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
    },
    config = function()
        require("opencode").setup({
            preferred_picker = "fzf",
            default_global_keymaps = true,
            keymap_prefix = "<leader>o",
            keymap = {
                editor = {
                    ["<leader>og"] = false,
                    ["<leader>uo"] = { "toggle" },
                    ["<leader>om"] = {
                        function()
                            local state = require("opencode.state")
                            local api = require("opencode.api")
                            if state.current_mode == "plan" then
                                api.agent_build()
                            else
                                api.agent_plan()
                            end
                        end,
                        desc = "Toggle build/plan mode"
                    },
                },
            },
        })
    end,
}
