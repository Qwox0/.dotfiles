if not require("qwox.util").has_plugins("cmp", "luasnip", "lspkind") then return end
local cmp = require("cmp")

vim.opt.completeopt = { "menu", "menuone", "preview" }

local confirm_opt = {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true
} -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

---create mapping for insert and cmdline mode
local function cmdlinemap(mappings)
    for k, map in pairs(mappings) do
        if type(map) == 'function' then
            mappings[k] = {
                i = map,
                c = map,
            }
        end
    end
    return mappings
end

local mapping = cmp.mapping.preset.insert(cmdlinemap {
    ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping.confirm(confirm_opt),
    ["<C-i>"] = cmp.mapping.confirm(confirm_opt),
    ["<C-Space>"] = cmp.mapping.complete(), -- What is the difference?
    --["<C-Space>"] = cmp.mapping.confirm(confirm_opt),
})

cmp.setup {
    enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
    end,
    mapping = mapping,

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    -- order == priority
    -- multiple args == grouping
    sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
        { name = "luasnip" },

        -- }, {

        { name = "crates" },

        { name = "buffer" },
    }),

    matching = {
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = false,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
    },

    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            -- cmp.config.compare.kind,
            cmp.config.compare.score,
            cmp.config.compare.kind,

            -- from lukas-reineke/cmp-under-comparator.
            function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find "^_+"
                local _, entry2_under = entry2.completion_item.label:find "^_+"
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                    return false
                elseif entry1_under < entry2_under then
                    return true
                end
            end,

            -- cmp.config.compare.recently_used,
            -- cmp.config.compare.locality,
            -- cmp.config.compare.kind,
            cmp.config.compare.length,
            -- cmp.config.compare.order,
        },
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
        --fields = { "kind", "abbr" }, --, "menu" },
        fields = { "kind", "abbr", "menu" },
        --[[

        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. ""
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
        end,
        ]]
        format = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "…", -- must define maxwidth first!
            menu = {
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
                gh_issues = "[issues]",
                tn = "[TabNine]",
            },
            before = function(entry, vim_item)
                return vim_item
            end
        }),
    },

    experimental = {
        -- new menu = better
        native_menu = false,
        ghost_text = true,
    }
}

-- Set configuration for specific filetype.
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
        { name = "dap" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "buffer" },
    }
})

cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "cmp_git" },
        { name = "buffer" },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline({
        ["<C-j>"] = {
            c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        },
        ["<Tab>"] = {
            c = cmp.mapping.confirm({ select = false }),
        }
    }),
    sources = {
        { name = "buffer" },
    }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
    -- mapping = mapping,
    mapping = cmp.mapping.preset.cmdline(mapping),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "buffer" },
        { name = "cmdline" },
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
    require("qwox.util").hl.set(name, opts)
end

if not require("qwox.util").has_plugins("nvim-autopairs.completion.cmp") then return end
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)
