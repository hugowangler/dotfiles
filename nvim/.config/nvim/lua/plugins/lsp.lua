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
            local ty_inlay_hints = {
                variableTypes = false,
                callArgumentNames = true,
            }

            local function set_ty_inlay_hint(bufnr, name, enabled)
                ty_inlay_hints[name] = enabled

                for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "ty" })) do
                    client.config.settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
                        ty = {
                            inlayHints = ty_inlay_hints,
                        },
                    })
                    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end

                if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
                    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                vim.notify("ty " .. name .. " hints: " .. (enabled and "ON" or "OFF"))
            end

            -- Shared config for all servers
            vim.lsp.config("*", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Python
            vim.lsp.config("ty", {
                settings = {
                    ty = {
                        diagnosticMode = "off",
                        inlayHints = ty_inlay_hints,
                    },
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

                    if client.name == "ruff" then
                        client.server_capabilities.completionProvider = nil
                    end

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
                    end

                    -- Neovim 0.11 built-ins: K, grr, grn, gra
                    -- Custom keymaps for actions without built-in bindings
                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gD", vim.lsp.buf.implementation, "Go to implementation")
                    map("n", "grt", vim.lsp.buf.type_definition, "Go to type definition")
                    map("n", "<leader>qf", function()
                        require("fzf-lua").lsp_code_actions({
                            previewer = false,
                            winopts = {
                                height = 0.35,
                                width = 0.60,
                                row = 0.45,
                                col = 0.50,
                            },
                            fzf_opts = {
                                ["--info"] = "hidden",
                            },
                        })
                    end, "Code action")
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
                    if client.name == "ty" then
                        map("n", "<leader>uv", function()
                            set_ty_inlay_hint(args.buf, "variableTypes", not ty_inlay_hints.variableTypes)
                        end, "Toggle ty variable type hints")
                        map("n", "<leader>ua", function()
                            set_ty_inlay_hint(args.buf, "callArgumentNames", not ty_inlay_hints.callArgumentNames)
                        end, "Toggle ty call argument hints")
                    end
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
