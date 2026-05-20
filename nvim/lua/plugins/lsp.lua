local function config()
    local qwox_lsp = require("qwox.lsp")

    require("mason").setup()
    require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_keys(qwox_lsp.servers),
        automatic_installation = false,
    }
    require("mason-lspconfig").setup_handlers { qwox_lsp.setup_server }

    --qwox_lsp.setup_server("postgres_lsp", { workspace_required = false })

    qwox_lsp.keymap()

    require("qwox.mylang").setup_lsp()

    --vim.colors.set("LspInlayHint", { fg = "#D3D3D3", bg = "#3A3A3A", italic = true })
    --vim.colors.set("LspInlayHint", { link = "GruvboxGray", italic = true })
    vim.colors.set("LspInlayHint", { link = "GruvboxBg3", italic = true })
    vim.colors.flatten_unlink("LspInlayHint", "keep")
    vim.lsp.inlay_hint.enable(true)

    require("fidget").setup()
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim",           version = "1.11.0" },
        { "williamboman/mason-lspconfig.nvim", version = "1.32.0" },
        { "j-hui/fidget.nvim",                 tag = "legacy" }, -- Useful status UI for LSP
        "ray-x/lsp_signature.nvim",                              -- show block signature
        "onsails/lspkind-nvim",                                  -- LSP Symbols
        "rachartier/tiny-inline-diagnostic.nvim",

        "nvim-telescope/telescope.nvim",
        "hrsh7th/cmp-nvim-lsp",

        { "folke/neodev.nvim", opts = {} }, -- setup lua_ls for nvim
    },
    config = config,
}
