if not require("qwox.util").has_plugins("gitsigns") then return end
require("gitsigns").setup {
    signs                        = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
    },
    signcolumn                   = false, -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
        follow_files = true
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

local colors = require("qwox.colors")

for _, x in ipairs({ "Add", "Change", "Delete" }) do
    colors.update_hl("GitSigns" .. x, { bg = "none" })
end


--[[
local c = require("qwox.colors")
local hl = c.set_hl

hl("GitSignsUntracked", { bg = "none", ctermbg = 234, ctermfg = 142, fg = 12106534 })
hl("GitSignsAdd", { bg = "none", ctermbg = 234, ctermfg = 142, fg = 12106534 })

c.get_hl("GitSignsUntrackedLn")
]]
-- setup "mhinz/vim-signify"
-- vim.g.signify_sign_add = "│"
-- vim.g.signify_sign_delete = "│"
-- vim.g.signify_sign_change = "│"
--
