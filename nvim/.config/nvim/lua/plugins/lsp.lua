return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "gopls",
                "lua_ls",
                "bashls",
            },
            automatic_enable = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Shared config for all servers
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Python
            vim.lsp.config("ty", {
                settings = {
                    ty = {},
                },
            })
            vim.lsp.config("ruff", {
                init_options = {
                    settings = {
                        lineLength = 120,
                    },
                },
            })
            vim.lsp.enable("ty")
            vim.lsp.enable("ruff")

            -- Go
            vim.lsp.config("gopls", {})

            -- Lua (lazydev.nvim handles workspace/library config)
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            -- Bash
            vim.lsp.config("bashls", {})

            -- Diagnostics
            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = true },
                virtual_text = { prefix = "●" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "●",
                        [vim.diagnostic.severity.WARN] = "●",
                        [vim.diagnostic.severity.INFO] = "●",
                        [vim.diagnostic.severity.HINT] = "●",
                    },
                },
            })

            -- Format on save (toggleable with <leader>uf)
            vim.g.autoformat = true

            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
                callback = function()
                    if vim.g.autoformat then
                        vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
                    end
                end,
            })

            vim.keymap.set("n", "<leader>uf", function()
                vim.g.autoformat = not vim.g.autoformat
                vim.notify("Format on save: " .. (vim.g.autoformat and "ON" or "OFF"))
            end, { desc = "Toggle format on save" })

            -- Keymaps and per-attach logic
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    -- Enable inlay hints when supported
                    if client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                    end

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
                    end

                    -- Neovim 0.11 built-ins: gd, K, grr, gri, grn, gra
                    -- Custom keymaps for actions without built-in bindings
                    map("n", "grt", vim.lsp.buf.type_definition, "Go to type definition")
                    map("n", "<leader>qf", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
                    map("n", "gn", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
                    map("n", "gp", function() vim.diagnostic.jump({ count = -1, float = true }) end,
                        "Previous diagnostic")
                    map("n", "gl", vim.diagnostic.open_float, "Show diagnostic float")
                    map("n", "<leader>uh", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
                            { bufnr = args.buf }
                        )
                    end, "Toggle inlay hints")
                    map("n", "<leader>ud", function()
                        vim.diagnostic.enable(
                            not vim.diagnostic.is_enabled({ bufnr = args.buf }),
                            { bufnr = args.buf }
                        )
                    end, "Toggle diagnostics")
                end,
            })
        end,
    },
}
