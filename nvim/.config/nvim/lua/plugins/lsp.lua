return {
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
                "pyright",
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
            vim.lsp.config("pyright", {
                settings = {
                    pyright = {
                        -- Let ruff handle import sorting
                        disableOrganizeImports = true,
                    },
                },
            })

            vim.lsp.config("ruff", {})
            vim.lsp.enable("ruff")

            -- Go
            vim.lsp.config("gopls", {})

            -- Lua
            vim.lsp.config("lua_ls", {
                on_init = function(client)
                    -- Respect .luarc.json if present
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                            return
                        end
                    end
                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                    })
                end,
                settings = {
                    Lua = {},
                },
            })

            -- Bash
            vim.lsp.config("bashls", {})

            -- Keymaps and per-attach logic
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    -- Disable ruff hover in favor of pyright
                    if client.name == "ruff" then
                        client.server_capabilities.hoverProvider = false
                    end

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gr", vim.lsp.buf.references, "Go to references")
                    map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
                    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>qf", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
                    map("n", "gn", vim.diagnostic.goto_next, "Next diagnostic")
                    map("n", "gp", vim.diagnostic.goto_prev, "Previous diagnostic")
                end,
            })
        end,
    },
}
