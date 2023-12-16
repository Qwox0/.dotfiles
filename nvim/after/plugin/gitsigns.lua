if not require("qwox.util").has_plugins("gitsigns") then return end
require("gitsigns").setup {
    signs                        = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "⬎" },
        topdelete    = { text = "⬏" },
        changedelete = { text = "~" },
        untracked    = { text = "│" }, -- ┆
    },
    signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = true, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
        follow_files = true,
    },
    attach_to_untracked          = true,
    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil,   -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
    },
    yadm                         = {
        enable = false
    },
}

local colors = require("typed.colors")

colors.flatten_unlink_hl("GitSignsAdd", "keep")
colors.update_hl("GitSignsAdd", { fg = "#50fa7b" })
colors.update_hl("GitSignsChange", { link = "GruvboxYellowSign" })
colors.update_hl("GitSignsDelete", { link = "GruvboxRedSign" })
colors.update_hl("GitSignsChangedelete", { link = "GruvboxOrangeSign" })
colors.update_hl("GitSignsChangedeleteNr", { link = "GitSignsChangedelete" })

local function get_inline(s)
    return { underdotted = true, sp = colors.get_active_hl("GitSigns" .. s).fg }
end
colors.update_hl("GitSignsAddInline", get_inline("Add"))
colors.update_hl("GitSignsChangeInline", get_inline("Change"))
colors.update_hl("GitSignsChangedeleteInline", get_inline("Changedelete"))
colors.update_hl("GitSignsDeleteInline", get_inline("Delete"))
