return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter",
    opts = {
        ensure_installed = {
            "bash",
            "go",
            "gomod",
            "gosum",
            "json",
            "lua",
            "markdown",
            "python",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
    },
}
