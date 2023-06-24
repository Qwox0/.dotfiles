local qwox_util = require("qwox.util")
if not qwox_util.has_plugins("rust-tools") then return end

qwox_util.set_hl("RustToolsInlayHint", { fg = "#D3D3D3", bg = "#3A3A3A", italic = true })

local qwox_lsp = require("qwox.lsp")

-- dap paths
local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
local codelldb_path = extension_path .. "/adapter/codelldb"
local liblldb_path = extension_path .. "/lldb/lib/liblldb"

if qwox_util.os.is_windows then
    codelldb_path = codelldb_path .. ".exe"
    liblldb_path = liblldb_path .. ".dll"
end
if qwox_util.os.is_linux then liblldb_path = liblldb_path .. ".so" end

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
        capabilities = qwox_lsp.capabilities,
        on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>dd", ":RustDebuggables<CR>", { buffer = bufnr, desc = "Rust [D]ebuggables" })
            vim.keymap.set("n", "<leader>rr", ":RustRunnables<CR>", { buffer = bufnr, desc = "[R]ust [R]unnables" })
            qwox_lsp.custom_attach(client, bufnr)
        end,
        standalone = false, -- single file support
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    features = "all",
                },
                diagnostics = {
                    disabled = { "inactive-code" },
                },
                --[[
                check = {
                    allTargets = false,
                },
                --]]
            }
        },
    },
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
    },
}
