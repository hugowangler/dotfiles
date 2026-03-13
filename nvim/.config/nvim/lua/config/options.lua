local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- General
opt.updatetime = 200
opt.colorcolumn = "120"
opt.spelllang = "en"
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.winborder = "rounded"
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 8

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
