local _, telescope = pcall(require, "telescope.builtin")

local LSP = {}

LSP.servers = {
    --[[
    rust_analyzer = {
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
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
    --]]
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",                  -- Lua version (LuaJIT for Neovim)
                    path = vim.split(package.path, ";"), -- Setup your lua path
                },
                diagnostics = {
                    globals = { "vim" }, -- recognize the `vim` global
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        vim.fn.expand("$VIMRUNTIME/lua"),
                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    },
                    checkThirdParty = false,
                },
                telemetry = { enable = false, },
            },
        },
    },
}

function LSP.custom_attach(client, bufnr)
    -- Create a command `:Format` local to the LSP buffer
    local create_command = require("typed.command")
    create_command("Format", function(_)
        vim.lsp.buf.format()
    end, { buffer = bufnr, desc = "Format current buffer with LSP" })

    local map = function(mode, keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        require("typed.keymap").map(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    map("n", "<leader>jn", function() vim.lsp.buf.rename() end, "Re[n]ame")
    map("n", "<leader>ja", function() vim.lsp.buf.code_action() end, "Code [A]ction")
    map("n", "<leader>jf", function() vim.lsp.buf.format() end, "[F]ormat buffer")
    map("n", "<leader>jd", function() vim.diagnostic.open_float() end, "Show [D]iagnostics")

    -- map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    -- map("n", "gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    -- map("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("n", "gd", function() telescope.lsp_definitions() end, "[G]oto [D]efinition")
    map("n", "gI", function() telescope.lsp_implementations() end, "[G]oto [I]mplementation")
    map("n", "gD", function() vim.lsp.buf.declaration() end, "[G]oto [D]eclaration")
    map("n", "gr", function() telescope.lsp_references() end, "[G]oto [R]eferences")

    map({ "n", "i", "v" }, "<C-h>", function() vim.lsp.buf.hover() end, "[H]over Documentation")
    map({ "n", "i", "v" }, "<C-S-h>", function() vim.lsp.buf.signature_help() end, "Signature Documentation")

    map("n", "<leader>nd", function() vim.diagnostic.goto_next() end, "[N]ext [D]iagnostic")
    map("n", "<leader>bd", function() vim.diagnostic.goto_prev() end, "previous [D]iagnostic")
    map("n", "<leader>ne", function() telescope.diagnostics { severity_limit = 1 } end, "[N]ext [E]rror")
    map("n", "<leader>be", function() telescope.diagnostics { severity_limit = 1 } end, "previous [E]rror")

    map("n", "<leader>ds", function() telescope.lsp_document_symbols() end, "[D]ocument [S]ymbols")
    map("n", "<leader>ws", function() telescope.lsp_dynamic_workspace_symbols() end, "[W]orkspace [S]ymbols")
    -- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    -- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    -- map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "[W]orkspace [L]ist Folders")
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
LSP.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

return LSP
