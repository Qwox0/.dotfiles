local qwox_util = require("qwox.util")
local map = require("typed.keymap").map
local nmap = require("typed.keymap").nmap
local imap = require("typed.keymap").imap
local vmap = require("typed.keymap").vmap
local xmap = require("typed.keymap").xmap

vim.g.mapleader = " "   -- keymapping: define <leader> for mappings
vim.opt.timeout = false -- keymapping: command timeout

map({ "n", "v" }, "<leader>", "<Nop>", { desc = "Remove default behavior of the leader key" })
nmap("q:", "<Nop>", { desc = "Disable command history" })
nmap("Q", "<Nop>", { desc = "Disable Q" })

nmap("k", "v:count == 0 ? \"gk\" : \"k\"", { expr = true, desc = "jump up in wrapped lines" })
nmap("j", "v:count == 0 ? \"gj\" : \"j\"", { expr = true, desc = "jump down in wrapped lines" })

--imap("<C-i>", "<Esc>I", { desc = "jump to line end" })
--imap("<C-a>", "<Esc>A", { desc = "jump to line start" })

vmap("J", ":m '>+1<CR>gv=gv", { desc = "move entire line down" })
vmap("K", ":m '<-2<CR>gv=gv", { desc = "move entire line up" })

nmap("J", "mzJ`z", { desc = "don't move cursor on J" })

nmap("<C-d>", "<C-d>zz", { desc = "center screen on Ctrl+d" })
nmap("<C-u>", "<C-u>zz", { desc = "center screen on Ctrl+u" })
nmap("n", "nzzzv", { desc = "center screen on n" })
nmap("N", "Nzzzv", { desc = "center screen on N" })

nmap("<leader>e", vim.cmd.Ex, { desc = "explore with vim file manager" })

imap("<C-c>", "<Esc>", { desc = "Ctrl+C = Esc" })
imap("<C-v>", "<C-r>\"", { desc = "Ctrl+V = Paste" })

xmap("<leader>p", "\"_dP", { desc = "paste but keep copy buffer" })
nmap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "make file e[x]ecutable" })

-- Substitute / Replace
nmap("<leader>ra", function()
    local search = vim.fn.input("Find > ") --TODO: highlight searched text
    vim.api.nvim_command("/" .. search)
    local replacement = vim.fn.input("Replace with > ")
    vim.api.nvim_command(":%s/" .. search .. "/" .. replacement .. "/g")
end, { desc = "[R]eplace [A]ll" })
nmap("<leader>rw", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], {
    desc = "[R]eplace [W]ord"
})
vmap("<leader>r", [["ay<CR>:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]], {
    desc = "[R]eplace highlight"
})

nmap("<leader>rf", function()
    local current_file_name = vim.api.nvim_buf_get_name(0)
    local new_file_name = vim.fn.input {
        prompt = current_file_name .. " | new name > ",
        default = current_file_name,
    }
    if new_file_name == "" or new_file_name == current_file_name then return end
    vim.fn.rename(current_file_name, new_file_name)
    vim.api.nvim_buf_set_name(0, new_file_name)
    vim.fn.execute("edit")
end, { desc = "[R]ename [F]ile" })

nmap("<leader>b", ":bprevious<CR>", { desc = "previous buffer ([B]ack)" })
nmap("<leader>n", ":bnext<CR>", { desc = "[N]ext buffer" })
nmap("<leader>q", ":bdelete<CR>", { desc = "[Q]uit buffer" })
nmap("<leader>!q", ":bdelete!<CR>", { desc = "[Q]uit buffer[!]" })

nmap("<leader>ji", "mzgg=G`z", { desc = "[I]ndent current buffer" })

nmap("<leader>ya", "mzggyG`z", { desc = "[Y]ank [A]ll in current buffer" })
nmap("<leader>da", "ggdG", { desc = "[D]elete [A]ll in current buffer" })

--#region surround

nmap("<leader>s", function()
    ---@type string
    local input = vim.fn.input("Surround word with > ")
    if input == "" then return end

    local before, word, after = qwox_util.get_cursor_word()

    qwox_util.set_line(nil, before .. input .. word .. input:fancy_reverse() .. after)
end, { desc = "[S]urround word" })

vmap("<leader>s", function()
    ---@type string
    local input = vim.fn.input("Surround selection with > ")
    if input == "" then return end

    local start_row, start_col, end_row, end_col = qwox_util.get_visual_pos()
    start_col = start_col - 1

    if start_row == end_row then
        ---@type string
        local line = qwox_util.get_line()
        local before, selection, after = line:multi_split(start_col, end_col)
        after = after or ""
        qwox_util.set_line(nil, before .. input .. selection .. input:fancy_reverse() .. after)
    elseif qwox_util.is_visual_block_mode() then
        for row = start_row, end_row, 1 do
            local before, selection, after = qwox_util.get_line(row):multi_split(start_col, end_col)
            if selection == nil or selection == "" then goto continue end
            qwox_util.set_line(row, before .. input .. selection .. input:fancy_reverse() .. (after or ""))
            ::continue::
        end
    else
        local before, selection_start = qwox_util.get_line(start_row):multi_split(start_col)
        local selection_end, after = qwox_util.get_line(end_row):multi_split(end_col)
        qwox_util.set_line(start_row, before .. input .. selection_start)
        qwox_util.set_line(end_row, selection_end .. input:fancy_reverse() .. after)
    end
    qwox_util.enter_normal_mode() -- alternative: move/expand selection
end, { desc = "[S]urround selection" })

--#endregion surround

--#region Git keymaps

-- if not qwox_util.has_plugins("vim-fugitive") then return end

nmap("<leader>gg", vim.cmd.Git, { desc = "[G]it: open fugitive" })
nmap("<leader>gs", require("telescope.builtin").git_status, { desc = "[G]it: [S]tatus" })
nmap("<leader>gb", require("telescope.builtin").git_branches, { desc = "[G]it: [B]ranches" })
nmap("<leader>gf", ":Git fetch<CR>", { desc = "[G]it: [F]etch" })
nmap("<leader>gd", ":Git pull<CR>", { desc = "[G]it: Pull [D]own" })
nmap("<leader>gu", ":Git push<CR>", { desc = "[G]it: Push [U]p" })
nmap("<leader>gy", ":Git fetch<CR>:Git pull<CR>:Git push<CR>", {
    desc = "[G]it: s[Y]nc (fetch, pull, push)"
})

nmap("<leader>gh", ":diffget //2<CR>", {desc = "diffsplit [G]et left ([H])"})
nmap("<leader>gl", ":diffget //3<CR>", {desc = "diffsplit [G]et right ([L])"})

nmap("<leader>gaa", ":!git add -A<CR>", { desc = "[G]it: [A]dd [A]ll" })

-- for fugitive:
nmap("gh", ":diffget //2<CR>", { desc = "fugitive split: [G]et left(2)" })
nmap("gj", ":diffget //3<CR>", { desc = "fugitive split: [G]et down(3)" })
nmap("gk", ":diffget //2<CR>", { desc = "fugitive split: [G]et up(2)" })
nmap("gl", ":diffget //3<CR>", { desc = "fugitive split: [G]et right(3)" })


--nmap("<leader>ga", require("telescope.builtin").git_stash, { desc = "[G]it: [A]dd" })

--#endregion Git keymaps
