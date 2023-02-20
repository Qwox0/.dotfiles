local ok, telescope = pcall(require, "telescope")
if not ok then print("Warn: telescope is missing!"); return end
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then print("Warn: cmp_nvim_lsp is missing!"); return end
local ok, mason = pcall(require, "mason")
if not ok then print("Warn: mason is missing!"); return end
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then print("Warn: lspconfig is missing!"); return end
local ok, fidget = pcall(require, "fidget")
if not ok then print("Warn: fidget is missing!"); return end

local custom_attach = function(client, bufnr)
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

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    rust_analyzer = {
        ["rust-analyzer"] = {
            diagnostics = {
                disabled = { "inactive-code" },
            }
        }
    },
    sumneko_lua = {
        Lua = {
            runtime = {
                version = "LuaJIT", -- Lua version (LuaJIT for Neovim)
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
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = custom_attach,
            settings = servers[server_name],
        }
    end,
}

-- Turn on lsp status information
require("fidget").setup()
