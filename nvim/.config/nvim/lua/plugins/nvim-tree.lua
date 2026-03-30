return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "echasnovski/mini.icons" },
    keys = {
        { "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer" },
    },
    opts = {
        view = {
            width = 50,
            number = true,
            relativenumber = true,
        },
        filters = {
            dotfiles = false,
            git_ignored = false,
            custom = {
                "^\\.git$",
                "node_modules",
                "__pycache__",
                "\\.pyc$",
                "\\.pytest_cache",
                "\\.mypy_cache",
                "\\.ruff_cache",
                "^\\.tmp",
                "coverage",
                "\\.next",
                "htmlcov",
                "venv",
            },
        },
        actions = {
            open_file = {
                quit_on_open = true,
                window_picker = {
                    enable = false,
                },
            },
        },
    },
}
