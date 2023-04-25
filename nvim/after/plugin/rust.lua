if not require("qwox.util").has_plugins("rust-tools") then return end

require("qwox.util").set_hl("RustToolsInlayHint", { fg = "#D3D3D3", bg = "#3A3A3A", italic = true })
vim.keymap.set("n", "<leader>dd", ":RustDebuggables<CR>", { desc = "[D]ebug" })

local _, custom_attach, capabilities = require("qwox.lsp"):unpack()

-- dap paths
local extension_path = vim.fn.stdpath("data") .. '/mason/packages/codelldb/extension'
local codelldb_path = extension_path .. '/adapter/codelldb'
local liblldb_path = extension_path .. '/lldb/lib/liblldb.so'

require("rust-tools").setup {
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "» ",
            highlight = "RustToolsInlayHint"
        },
    },
    server = {
        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
        capabilities = capabilities,
        on_attach = custom_attach,
        standalone = false, -- single file support
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    features = "all",
                },
                diagnostics = {
                    disabled = { "inactive-code" },
                }
            }
        },
    },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
    },
}
