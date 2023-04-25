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
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                    checkThirdParty = false,
                },
                telemetry = { enable = false, },
            },
        },
    },
}

LSP.custom_attach = function(client, bufnr)
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    local map = function(mode, keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
    end

    map("n", "<leader>jn", vim.lsp.buf.rename, "Re[n]ame")
    map("n", "<leader>ja", vim.lsp.buf.code_action, "Code [A]ction")
    map("n", "<leader>jf", vim.lsp.buf.format, "[F]ormat buffer")
    map("n", "<leader>jd", vim.diagnostic.open_float, "Show [D]iagnostics")

    map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("n", "gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    -- map("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

    map({ "n", "i", "v" }, "<C-h>", vim.lsp.buf.hover, "Hover Documentation")
    map({ "n", "i", "v" }, "<C-S-h>", vim.lsp.buf.signature_help, "Signature Documentation")

    map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")
end


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
LSP.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

function LSP:unpack()
    return self.servers, self.custom_attach, self.capabilities
end

return LSP
