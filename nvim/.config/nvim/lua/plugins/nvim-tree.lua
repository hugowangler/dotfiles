return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                width = 50,
                number = true,
                relativenumber = true,
            },
            renderer = {
                icons = {
                    show = {
                        git = true,
                        file = true,
                        folder = true,
                    },
                },
            },
            filters = {
                dotfiles = false,
                custom = {
                    "^\\.git$",
                    "node_modules",
                    "__pycache__",
                    "\\.pyc$",
                    "\\.pytest_cache",
                    "\\.mypy_cache",
                    "coverage",
                    "\\.next",
                    "htmlcov",
                    "venv",
                },
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
        })
    end,
}
