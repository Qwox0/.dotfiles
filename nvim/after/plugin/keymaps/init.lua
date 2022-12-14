-- define keymapping in vim style
-- <leader> is defined in lua/qwox/sets.lua
-- functions: "<mode>[no recursive]map"
-- <mode>: n(normal), v(visual), x(), i(insert)
local nnoremap = require("qwox.keymap").nnoremap
local inoremap = require("qwox.keymap").inoremap
local vnoremap = require("qwox.keymap").vnoremap
local xnoremap = require("qwox.keymap").xnoremap
local qwox_util = require("qwox.util")

-- -- -- Basic
nnoremap("k", "v:count == 0 ? \"gk\" : \"k\"", "jump up inside wrapped line", { expr = true })
nnoremap("j", "v:count == 0 ? \"gj\" : \"j\"", "jump down inside wrapped line", { expr = true })

inoremap("<C-a>", "<Esc>A", "jump to line start")
--inoremap("<C-i>", "<Esc>I", "jump to line end")

nnoremap("<leader>e", ":Ex<CR>", "explore with vim file manager")
vnoremap("J", ":m '>+1<CR>gv=gv", "move entire line down")
vnoremap("K", ":m '<-2<CR>gv=gv", "move entire line up")

nnoremap("<C-d>", "<C-d>zz", "center cursor on Ctrl-d")
nnoremap("<C-u>", "<C-u>zz", "center cursor on Ctrl-u")
-- zv: some extra folding stuff
nnoremap("n", "nzzzv", "center cursor on search next")
nnoremap("N", "Nzzzv", "center cursor on search previous")


xnoremap("<leader>p", "\"_dP", "paste but keep copy buffer")

nnoremap("<leader>ra", function()
    local search = vim.fn.input("Find > ") --TODO: highlight searched text
    vim.api.nvim_command("/" .. search)
    local replacement = vim.fn.input("Replace with > ")
    vim.api.nvim_command(":%s/" .. search .. "/" .. replacement .. "/g")
end, "replace all (:%s/../../g)")

-- -- -- buffer, window, tab
--[[ Explanation
    A buffer is the in-memory text of a file.   file
    A window is a viewport on a buffer.         buffer view
    A tab page is a collection of windows.      window collection]]

nnoremap("<leader>b", ":bprevious<CR>", "previous buffer")
nnoremap("<leader>n", ":bnext<CR>", "next buffer")
nnoremap("<leader>q", ":bp<CR>:bd #<CR>", "close buffer")

-- split Window
local smove = require("qwox.screen").move
nnoremap("<leader>h", smove("left"), "move to window on the left")
nnoremap("<leader>j", smove("down"), "move to window below")
nnoremap("<leader>k", smove("up"), "move to window above")
nnoremap("<leader>l", smove("right"), "move to window on the right")
--[[
local snew = require("qwox.screen").new
nnoremap("<leader>H", snew("left")) -- vertical split
nnoremap("<leader>J", snew("down")) -- horizontal split
nnoremap("<leader>K", snew("up")) -- horizontal split
nnoremap("<leader>L", snew("right")) -- vertical split
]]


local get_padding = function(len, max_len, base_padding)
    local padding = base_padding or ""
    for _ = 1, max_len - len, 1 do padding = padding .. " " end
    return padding
end

-- show custom keymaps
nnoremap("<leader>s", function()
    local lines = { "Custom Mappings:" }
    local mappings = vim.tbl_extend("force",
        { { op = "mode", lhs = "mapping", description = "description" } },
        require("qwox.keymap").help_menu)
    local max_lhs_len, max_op_len = 0, 0
    for _, v in pairs(mappings) do
        max_lhs_len = math.max(max_lhs_len, #v.lhs)
        max_op_len = math.max(max_op_len, #v.op)
    end
    for _, v in pairs(mappings) do
        lines[#lines + 1] = v.op ..
            get_padding(#v.op, max_op_len) .. "|" ..
            v.lhs .. get_padding(#v.lhs, max_lhs_len, "   ") .. "|" ..
            v.description
    end
    qwox_util.open_window(lines)
end, "show this help menu")
