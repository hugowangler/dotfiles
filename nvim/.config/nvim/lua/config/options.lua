-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Tabs & indentation
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- General
vim.o.updatetime = 200
vim.o.colorcolumn = "120"
vim.o.spelllang = "en"
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.undofile = true
vim.o.winborder = "rounded"
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 8
vim.o.wrap = false

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0

-- Filetype overrides
vim.filetype.add({
    pattern = {
        [".*%.env"] = "dotenv",
        [".*%.env%..*"] = "dotenv",
    },
})
