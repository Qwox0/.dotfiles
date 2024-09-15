local completeopt = { "menu", "menuone", "preview" }
function completeopt:as_str()
    return table.concat(self, ",")
end

local function get_my_kind_priorities()
    local cmp = require("cmp")

    local my_kind_order = {
        cmp.lsp.CompletionItemKind.Field,         -- (󰜢)
        cmp.lsp.CompletionItemKind.Property,      -- (󰜢)
        cmp.lsp.CompletionItemKind.EnumMember,    -- ()
        cmp.lsp.CompletionItemKind.Variable,      -- (󰀫)

        cmp.lsp.CompletionItemKind.Method,        -- (󰆧)
        cmp.lsp.CompletionItemKind.Constructor,   -- ()

        cmp.lsp.CompletionItemKind.Snippet,       -- ()
        cmp.lsp.CompletionItemKind.Function,      -- (󰊕)

        cmp.lsp.CompletionItemKind.Class,         -- (󰠱)
        cmp.lsp.CompletionItemKind.Struct,        -- (󰙅)
        cmp.lsp.CompletionItemKind.Enum,          -- ()
        cmp.lsp.CompletionItemKind.Interface,     -- ()

        cmp.lsp.CompletionItemKind.Module,        -- ()
        cmp.lsp.CompletionItemKind.Constant,      -- (󰏿)
        cmp.lsp.CompletionItemKind.TypeParameter, -- (T)

        cmp.lsp.CompletionItemKind.Unit,          -- (󰑭)
        cmp.lsp.CompletionItemKind.Value,         -- (󰎠)
        cmp.lsp.CompletionItemKind.Keyword,       -- (󰌋)
        cmp.lsp.CompletionItemKind.Color,         -- (󰏘)
        cmp.lsp.CompletionItemKind.File,          -- (󰈙)
        cmp.lsp.CompletionItemKind.Reference,     -- (󰈇)
        cmp.lsp.CompletionItemKind.Folder,        -- (󰉋)
        cmp.lsp.CompletionItemKind.Event,         -- ()
        cmp.lsp.CompletionItemKind.Operator,      -- (󰆕)

        cmp.lsp.CompletionItemKind.Text,          -- (󰉿)
    }

    local idx_tbl = {}

    for idx, kind in ipairs(my_kind_order) do
        idx_tbl[kind] = idx
    end

    return idx_tbl
end

---create mapping for insert and cmdline mode
---@param mappings table<string, function>
---@return table<string, { i: function, c: function, s: function }>
local function allmodes(mappings)
    local out = {}
    for k, map in pairs(mappings) do
        if type(map) == "function" then
            out[k] = { i = map, c = map, s = map }
        end
    end
    return out
end

---@return boolean
local function has_imports(entry)
    local item = entry:get_completion_item()
    --vim.notify(vim.inspect(item))
    local imports = item and item.data and item.data.imports or {}
    return vim.tbl_isempty(imports)
end

local function config()
    local cmp = require("cmp")

    vim.opt.completeopt = completeopt

    local confirm_opt = {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
    }

    local mapping = allmodes {
        ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.confirm(confirm_opt),
        ["<C-i>"] = cmp.mapping.confirm(confirm_opt),
        ["<C-Space>"] = cmp.mapping.complete(), -- What is the difference?
        --["<C-Space>"] = cmp.mapping.confirm(confirm_opt),
    }

    local my_kind_priorities = get_my_kind_priorities()

    cmp.setup {
        enabled = function()
            return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                or require("cmp_dap").is_dap_buffer()
        end,

        performance = nil,

        preselect = cmp.PreselectMode.None,

        completion = {
            autocomplete = {
                "InsertEnter",
                "TextChanged",
            },
            completeopt = completeopt:as_str(),
            keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
            keyword_length = 1,
        },

        window = {
            completion = {
                border = { '', '', '', '', '', '', '', '' },
                winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                scrolloff = 0,
                col_offset = -2,
                side_padding = 1,
                scrollbar = true,
            },
            documentation = {},
        },

        confirmation = {
            default_behavior = "insert",
            get_commit_characters = function(commit_character)
                return commit_character
            end,
        },

        matching = {
            disallow_fuzzy_matching = false,
            disallow_fullfuzzy_matching = false,
            disallow_partial_fuzzy_matching = false,
            disallow_partial_matching = false,
            disallow_prefix_unmatching = false,
        },

        sorting = {
            priority_weight = 2,
            comparators = {
                cmp.config.compare.exact,
                cmp.config.compare.offset,

                function(entry1, entry2) -- in scope first, imported last
                    local has_imports1 = has_imports(entry1)
                    local has_imports2 = has_imports(entry2)
                    if has_imports1 ~= has_imports2 then return has_imports1 end
                end,

                function(entry1, entry2)            -- custom kind
                    local kind1 = entry1:get_kind() --- @type number
                    local kind2 = entry2:get_kind() --- @type number
                    if kind1 ~= kind2 then
                        local diff = my_kind_priorities[kind1] - my_kind_priorities[kind2]
                        if diff < 0 then
                            return true
                        elseif diff > 0 then
                            return false
                        end
                    end
                end,

                cmp.config.compare.score,

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

                cmp.config.compare.length,
                cmp.config.compare.sort_text,
            },
        },

        formatting = {
            expandable_indicator = true,
            fields = { "kind", "abbr", "menu" },
            format = require("lspkind").cmp_format {
                mode = "symbol",
                maxwidth = 50,
                ellipsis_char = "…", -- must define maxwidth first!
                menu = {
                    buffer = "[Buf]",
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[api]",
                    path = "[Path]",
                    luasnip = "[Snip]",
                    gh_issues = "[Issues]",
                    tn = "[TabNine]",
                },
                before = function(entry, vim_item)
                    return vim_item
                end,
                symbol_map = {
                    TypeParameter = "T",
                },
            },
        },

        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },

        mapping = cmp.mapping.preset.insert(mapping),

        -- order == priority
        -- multiple args == grouping
        sources = cmp.config.sources {
            -- special
            { name = "nvim_lua" },
            { name = "crates" },
            { name = "obsidian" },

            -- lsp
            { name = "nvim_lsp" },
            { name = "nvim_lsp_signature_help" },
            { name = "path" },
            { name = "luasnip" },

            {
                name = "buffer",
                option = { keyword_pattern = [[\k\+]] },
            },
        },

        view = {
            entries = {
                name = "custom",
                -- selection_order = "near_cursor",
                selection_order = "top_down",
            },
            docs = {
                auto_open = true,
            }
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
        mapping = cmp.mapping.preset.cmdline(mapping),
        sources = {
            { name = "buffer" },
        },
        performance = {
            max_view_entries = 20,
        },
    })

    -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(mapping),
        sources = {
            { name = "path" },
            { name = "buffer" },
            { name = "cmdline" },
        },
    })

    local bg0_hard = "#1d2021"
    local bg0      = "#282828"
    local bg0_soft = "#32302f"
    local bg1      = "#3c3836"
    local bg2      = "#504945"
    local bg3      = "#665c54"
    local bg4      = "#7c6f64"

    -- colors
    vim.colors.set_many {
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
    }

    cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
end

return {
    "hrsh7th/nvim-cmp",
    event = {
        "InsertEnter",
        "CmdlineEnter",
    },
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-cmdline",

        "onsails/lspkind-nvim",

        -- Snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
    config = config,
}
