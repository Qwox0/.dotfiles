
vim.opt.list = true
--vim.opt.listchars = "tab:-->,space: ,trail:⋅,multispace:⋅,leadmultispace:⋅⋅⋅|,extends:…,"
vim.opt.listchars:append("eol:↴")
vim.opt.listchars:append("tab:-->")
vim.opt.listchars:append("space: ")
vim.opt.listchars:append("multispace:⋅")
vim.opt.listchars:append("leadmultispace:⋅⋅⋅│")
vim.opt.listchars:append("trail:⋅")
vim.opt.listchars:append("extends:…")
vim.opt.listchars:append("precedes:…")

-- tranparency doesn't work
--[[
vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { bg = "#ffff40" })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { bg = "#7fff7f" })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { bg = "#ff7fff" })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { bg = "#4fecec" })
]]
--vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { bg = "#353535" })
--vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { bg = "bg" })


if not require("qwox.util").has_plugins("indent_blankline") then return end

if true then return end -- DISABLED!

require("indent_blankline").setup({
    char = '│',
    --char_blankline = '┆',
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = true,
})
--[[
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "Normal",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "Normal",
    },
--]]
