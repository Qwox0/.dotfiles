if not require("qwox.util").has_plugins("telescope", "cmp_nvim_lsp", "mason", "lspconfig") then return end

local qwox_lsp = require("qwox.lsp")

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = vim.tbl_keys(qwox_lsp.servers),
    automatic_installation = false,
}
require("mason-lspconfig").setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup(
            vim.tbl_deep_extend("force", qwox_lsp.servers[server_name] or {}, {
                capabilities = qwox_lsp.capabilities,
                on_attach = qwox_lsp.custom_attach,
            })
        )
    end,
}

if not require("qwox.util").has_plugins("fidget") then return end
require("fidget").setup()
