local function config()
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

    require("fidget").setup()
end

return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        { "j-hui/fidget.nvim", tag = "legacy" }, -- Useful status UI for LSP
        "ray-x/lsp_signature.nvim",              -- show block signature
        "onsails/lspkind-nvim",                  -- LSP Symbols

        "nvim-telescope/telescope.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = config,
}
