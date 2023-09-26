local qwox_util = require("qwox.util")
if not qwox_util.has_plugins("rust-tools") then return end

qwox_util.set_hl("RustToolsInlayHint", { fg = "#D3D3D3", bg = "#3A3A3A", italic = true })

local qwox_lsp = require("qwox.lsp")
local nmap = require("qwox.keymap").nmap

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
            nmap("<leader>rr", ":RustRunnables<CR>", { buffer = bufnr, desc = "[R]ust [R]unnables" })
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
        --[[
        adapter = {
            type = "server",
            port = "${port}",
            host = "127.0.0.1",
            executable = {
                command = debugger_path,
                args = { "--server=${port}", "--pauseForDebugger" },
            },
        }
        ]]
    },
}
