if not require("qwox.util").has_plugins("telescope", "cmp_nvim_lsp", "mason", "lspconfig") then return end

local servers, custom_attach, capabilities = require("qwox.lsp"):unpack()

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = false,
}
require("mason-lspconfig").setup_handlers {
    function(server_name)
        --[[
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = custom_attach,
            settings = servers[server_name],
        }
        --]]
        require("lspconfig")[server_name].setup(
            vim.tbl_deep_extend("force", servers[server_name] or {}, {
                capabilities = capabilities,
                on_attach = custom_attach,
            })
        )
    end,
}

if not require("qwox.util").has_plugins("fidget") then return end
require("fidget").setup()
