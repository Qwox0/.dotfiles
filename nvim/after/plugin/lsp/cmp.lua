if not require("qwox.util").has_plugins("cmp", "luasnip", "lspkind") then return end
local cmp = require("cmp")

vim.opt.completeopt = { "menu", "menuone", "preview" }

local confirm_opt = {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true
} -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

cmp.setup {
    mapping = cmp.mapping.preset.insert({
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<Tab>"] = cmp.mapping.confirm(confirm_opt),
            ["<C-i>"] = cmp.mapping.confirm(confirm_opt),
            ["<C-Space>"] = cmp.mapping.complete(), -- What is the difference?
        --["<C-Space>"] = cmp.mapping.confirm(confirm_opt),
    }),

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    sources = { -- order == priority !!
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
        --{ name = "luasnip" },

        { name = "nvim_lua" },
        { name = "crates" },

        { name = "buffer" },
    },

    matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = false,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
    },

    sorting = {
        comperatos = function(entry1, entry2)
            print("a")
            local types = require("cmp.types")
            local kind1 = entry1:get_kind()
            kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
            local kind2 = entry2:get_kind()
            kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
            if kind1 ~= kind2 then
                --[[

                if kind1 == types.lsp.CompletionItemKind.Snippet then
                    return true
                end
                if kind2 == types.lsp.CompletionItemKind.Snippet then
                    return false
                end
                --]]
                local diff = kind1 - kind2
                if diff < 0 then
                    return true
                elseif diff > 0 then
                    return false
                end
            end
        end,
    },

    preselect = cmp.PreselectMode.None,

    view = {
        name = "custom",
        selection_order = "near_cursor",
    },

    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -2,
            side_padding = 0,
        },
    },

    formatting = {
        fields = { "kind", "abbr" }, --, "menu" },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. ""
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
        end,
        -- format = lspkind.cmp_format({
        --     mode = "symbol",
        --     maxwidth = 50,
        --     ellipsis_char = "…", -- must define maxwidth first!
        --     --[[
        --     menu = {
        --         buffer = "[Buf]",
        --         nvim_lsp = "[LSP]",
        --         nvim_lua = "[api]",
        --         path = "[path]",
        --         luasnip = "[snip]",
        --         gh_issues = "[issues]",
        --         tn = "[TabNine]",
        --     },
        --     ]]
        --     before = function(entry, vim_item)
        --         return vim_item
        --     end
        -- }),
    },

    experimental = {
        -- new menu = better
        native_menu = false,
        ghost_text = true,
    }
}

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

local bg0_hard = "#1d2021"
local bg0      = "#282828"
local bg0_soft = "#32302f"
local bg1      = "#3c3836"
local bg2      = "#504945"
local bg3      = "#665c54"
local bg4      = "#7c6f64"

-- colors
for name, opts in pairs {
    --PmenuSel = { fg = "NONE",bg = "#282C34" },
    PmenuSel              = { fg = "NONE", bg = "#000000" }, -- not working
    --PmenuSel              = { fg = "#C5CDD9", bg = bg2 },
    --Pmenu = { fg = "#C5CDD9", bg = "#22252A" },
    --Pmenu = { fg = "NONE", bg = "#22252A" },
    --Pmenu                 = { fg = "#C5CDD9", bg = bg1 },

    -- fg = "#82AAFF" "#83a598"
    -- CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true }, --, fmt = "strikethrough" },
    CmpItemAbbrMatch      = { fg = "#83A598", bg = "NONE", bold = true },
    CmpItemAbbrMatchFuzzy = { fg = "#83A598", bg = "NONE", bold = true },

    -- CmpItemMenu = { fg = "#C792EA", bg = "NONE" }, --, fmt = "italic" },

    --CmpItemKindField         = { fg = "#22252A", bg = "#B5585F" },
    --CmpItemKindProperty      = { fg = "#22252A", bg = "#B5585F" },
    --CmpItemKindEvent         = { fg = "#22252A", bg = "#B5585F" },
    --CmpItemKindText          = { fg = "#22252A", bg = "#9FBD73" },
    --CmpItemKindEnum          = { fg = "#22252A", bg = "#9FBD73" },
    --CmpItemKindKeyword       = { fg = "#22252A", bg = "#9FBD73" },
    --CmpItemKindConstant      = { fg = "#22252A", bg = "#D4BB6C" },
    --CmpItemKindConstructor   = { fg = "#22252A", bg = "#D4BB6C" },
    --CmpItemKindReference     = { fg = "#22252A", bg = "#D4BB6C" },
    --CmpItemKindFunction      = { fg = "#22252A", bg = "#A377BF" },
    --CmpItemKindStruct        = { fg = "#22252A", bg = "#A377BF" },
    --CmpItemKindClass         = { fg = "#22252A", bg = "#A377BF" },
    --CmpItemKindModule        = { fg = "#22252A", bg = "#A377BF" },
    --CmpItemKindOperator      = { fg = "#22252A", bg = "#A377BF" },
    --CmpItemKindVariable      = { fg = "#22252A", bg = "#7E8294" },
    --CmpItemKindFile          = { fg = "#22252A", bg = "#7E8294" },
    --CmpItemKindUnit          = { fg = "#22252A", bg = "#D4A959" },
    --CmpItemKindSnippet       = { fg = "#22252A", bg = "#D4A959" },
    --CmpItemKindFolder        = { fg = "#22252A", bg = "#D4A959" },
    --CmpItemKindMethod        = { fg = "#22252A", bg = "#6C8ED4" },
    --CmpItemKindValue         = { fg = "#22252A", bg = "#6C8ED4" },
    --CmpItemKindEnumMember    = { fg = "#22252A", bg = "#6C8ED4" },
    --CmpItemKindInterface     = { fg = "#22252A", bg = "#58B5A8" },
    --CmpItemKindColor         = { fg = "#22252A", bg = "#58B5A8" },
    --CmpItemKindTypeParameter = { fg = "#22252A", bg = "#58B5A8" },

} do
    require("qwox.util").set_hl(name, opts)
end

if not require("qwox.util").has_plugins("nvim-autopairs.completion.cmp") then return end
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)
