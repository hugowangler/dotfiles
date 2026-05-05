return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
        {
            "<leader>uc",
            function()
                require("copilot.suggestion").toggle_auto_trigger()
            end,
            desc = "Toggle Copilot suggestions",
        },
    },
    opts = {
        panel = {
            enabled = false,
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
                accept = "<C-y>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
                toggle_auto_trigger = false,
            },
        },
    },
}
