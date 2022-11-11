-- Setup nvim-cmp. See https://github.com/hrsh7th/nvim-cmp
local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then return end
local lspkind = require("lspkind")

local confirm_opt = {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true
} -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        --["<Tab>"] = cmp.mapping.confirm(confirm_opt),
        ["<C-i>"] = cmp.mapping.confirm(confirm_opt),

        --["<C-Space>"] = cmp.mapping.complete(),
        ["<C-Space>"] = cmp.mapping.confirm(confirm_opt),
    }),

    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },

    sources = { -- order == priority !!
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer" },

        { name = "crates" }
    },

    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol", -- show only symbol annotations
            --maxwidth = 50
            --ellipsis_char = "…", -- must define maxwidth first!
            --with_text = true,
            menu = {
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
                gh_issues = "[issues]",
                tn = "[TabNine]",
            },
        }),
    },

    experimental = {
        -- new menu = better
        native_menu = false,

        ghost_text = true,
    }
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = "buffer" },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})
