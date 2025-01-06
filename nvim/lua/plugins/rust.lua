local function config()
    local qwox_util = require("qwox.util")
    local qwox_lsp = require("qwox.lsp")

    -- workaround <https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525>
    for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
            if err ~= nil and err.code == -32802 then
                return
            end
            return default_diagnostic_handler(err, result, context, config)
        end
    end

    -- dap paths
    --[[
    local extension_path = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension"
    local debugger_path = extension_path .. "/debugAdapters/bin/OpenDebugAD7"
    ]]
    local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
    local codelldb_path = extension_path .. "/adapter/codelldb"
    local liblldb_path = extension_path .. "/lldb/lib/liblldb"
    if qwox_util.os.is_windows then
        codelldb_path = codelldb_path .. ".exe"
        liblldb_path = liblldb_path .. ".dll"
    end
    if qwox_util.os.is_linux then liblldb_path = liblldb_path .. ".so" end

    -- require("rust-tools").setup {
    --     tools = {
    --         inlay_hints = {
    --             show_parameter_hints = false,
    --             parameter_hints_prefix = "<- ",
    --             other_hints_prefix = "» ",
    --             highlight = "RustToolsInlayHint"
    --         },
    --     },
    --     server = {
    --         cmd = { "rustup", "run", "nightly", "rust-analyzer" },
    --         capabilities = qwox_lsp.capabilities,
    --         on_attach = function(client, bufnr)
    --             nmap("<leader>rr", ":RustRunnables<CR>", { buffer = bufnr, desc = "[R]ust [R]unnables" })
    --             qwox_lsp.custom_attach(client, bufnr)
    --         end,
    --         standalone = true, -- single file support
    --         settings = {
    --             ["rust-analyzer"] = {
    --                 cargo = {
    --                     features = "all",
    --                 },
    --                 diagnostics = {
    --                     disabled = { "inactive-code" },
    --                 },
    --                 hover = {
    --                     links = { enable = false }, -- don't write full links in docstring ("[`Ok`]" -> `Ok` (no link))
    --                 },
    --                 check = {
    --                     allTargets = true,
    --                 },
    --             }
    --         },
    --     },
    --     dap = {
    --         adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
    --         --[[
    --     adapter = {
    --         type = "server",
    --         port = "${port}",
    --         host = "127.0.0.1",
    --         executable = {
    --             command = debugger_path,
    --             args = { "--server=${port}", "--pauseForDebugger" },
    --         },
    --     }
    --     ]]
    --     },
    -- }

    vim.g.rustaceanvim = {
        tools = {
            --[[
            inlay_hints = {
                show_parameter_hints = false,
                parameter_hints_prefix = "<- ",
                other_hints_prefix = "» ",
                highlight = "RustToolsInlayHint"
            },
            ]]
        },
        server = {
            --cmd = { "rustup", "run", "nightly", "rust-analyzer" },
            --capabilities = qwox_lsp.capabilities,
            on_attach = function(client, bufnr)
                -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                --nmap("<leader>rr", ":RustRunnables<CR>", { buffer = bufnr, desc = "[R]ust [R]unnables" })
                qwox_lsp.custom_attach(client, bufnr)
            end,
            --standalone = true, -- single file support

            default_settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        features = "all",
                    },
                    diagnostics = {
                        disabled = { "inactive-code" },
                    },
                    hover = {
                        links = { enable = false }, -- don't write full links in docstring ("[`Ok`]" -> `Ok` (no link))
                    },
                    check = {
                        allTargets = true,
                    },
                    inlayHints = {
                        bindingModeHints = {
                            enable = false,
                        },
                        chainingHints = {
                            enable = true,
                        },
                        closingBraceHints = {
                            enable = true,
                            minLines = 25,
                        },
                        closureReturnTypeHints = {
                            enable = "never",
                        },
                        lifetimeElisionHints = {
                            enable = "never",
                            useParameterNames = false,
                        },
                        maxLength = 25,
                        parameterHints = {
                            enable = false,
                        },
                        renderColons = true,
                        typeHints = {
                            enable = true,
                            hideClosureInitialization = false,
                            hideNamedConstructor = true,
                        },
                    },
                }
            },
        },
        dap = {
            adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
        }
    }
end

return {
    --"simrat39/rust-tools.nvim",
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = "rust",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    config = config,
}
