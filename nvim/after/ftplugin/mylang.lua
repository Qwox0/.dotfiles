vim.cmd [[
" Language:	Mylang
" Description:	Vim ftplugin for Mylang (name will change)

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo&vim

setlocal comments=s0:/*!,ex:*/,s1:/*,mb:*,ex:*/,:///,://!,://
" also include multiline string literals to automatically insert `\\ `.
setlocal comments+=:\\\\
setlocal commentstring=//\ %s
setlocal formatoptions-=t formatoptions+=croqnl
" j was only added in 7.3.541, so stop complaints about its nonexistence
silent! setlocal formatoptions+=j

let &cpo = s:save_cpo
unlet s:save_cpo
]]

-- telescope keymaps with emulate some lsp features
local telescope = require("telescope.builtin")

local map = function(mode, keys, func, desc)
    if desc then desc = "LSP: " .. desc end
    vim.keymap.set(mode, keys, func, { buf = 0, desc = desc })
end

map("n", "gd", function()
    telescope.grep_string {
        search = "^\\s*" .. qwox.get_cursor_word() .. "\\s*:",
        use_regex = true,
    }
end, "[G]oto [D]efinition")
map("n", "gr", function()
    telescope.grep_string {
        search = "\\<" .. qwox.get_cursor_word() .. "\\>",
        use_regex = true,
    }
end, "[G]oto [R]eferences")
