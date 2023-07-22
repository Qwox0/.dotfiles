local qwox_util = require("qwox.util")

vim.g.mapleader = " "   -- keymapping: define <leader> for mappings
vim.opt.timeout = false -- keymapping: command timeout


vim.keymap.set({ "n", "v" }, "<leader>", "<Nop>", { desc = "Remove default behavior of the leader key" })
vim.keymap.set("n", "q:", "<Nop>", { desc = "Disable command history" })
vim.keymap.set("n", "Q", "<Nop>", { desc = "Disable Q" })

vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { expr = true, desc = "jump up in wrapped lines" })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { expr = true, desc = "jump down in wrapped lines" })

--vim.keymap.set("i", "<C-i>", "<Esc>I", { desc = "jump to line end" })
--vim.keymap.set("i", "<C-a>", "<Esc>A", { desc = "jump to line start" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move entire line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move entire line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "don't move cursor on J" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "center screen on Ctrl+d" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "center screen on Ctrl+u" })
vim.keymap.set("n", "n", "nzzzv", { desc = "center screen on n" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "center screen on N" })

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "explore with vim file manager" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Ctrl+C = Esc" })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "paste but keep copy buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "make file e[x]ecutable" })

-- Substitute / Replace
vim.keymap.set("n", "<leader>ra", function()
    local search = vim.fn.input("Find > ") --TODO: highlight searched text
    vim.api.nvim_command("/" .. search)
    local replacement = vim.fn.input("Replace with > ")
    vim.api.nvim_command(":%s/" .. search .. "/" .. replacement .. "/g")
end, { desc = "[R]eplace [A]ll" })
vim.keymap.set("n", "<leader>rw", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], {
    desc = "[R]eplace [W]ord"
})
vim.keymap.set("v", "<leader>r", [["ay<CR>:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]], {
    desc = "[R]eplace highlight"
})


vim.keymap.set("n", "<leader>rf", function()
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

vim.keymap.set("n", "<leader>b", ":bprevious<CR>", { desc = "previous buffer ([B]ack)" })
vim.keymap.set("n", "<leader>n", ":bnext<CR>", { desc = "[N]ext buffer" })
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "[Q]uit buffer" })
vim.keymap.set("n", "<leader>!q", ":bdelete!<CR>", { desc = "[Q]uit buffer[!]" })

vim.keymap.set("n", "<leader>ji", "mzgg=G`z", { desc = "[I]ndent current buffer" })

vim.keymap.set("n", "<leader>ya", "mzggyG`z", { desc = "[Y]ank [A]ll in current buffer" })
vim.keymap.set("n", "<leader>da", "ggdG", { desc = "[D]elete [A]ll in current buffer" })

--#region surround

vim.keymap.set("n", "<leader>s", function()
    ---@type string
    local input = vim.fn.input("Surround word with > ")
    if input == "" then return end

    local before, word, after = qwox_util.get_cursor_word()

    vim.api.nvim_set_current_line(before .. input .. word .. input:fancy_reverse() .. after)
end, { desc = "[S]urround word" })

vim.keymap.set("v", "<leader>s", function()
    ---@type string
    local input = vim.fn.input("Surround selection with > ")
    if input == "" then return end
    local start_row, start_col, end_row, end_col = qwox_util.get_visual_pos()
    start_col = start_col - 1

    if start_row == end_row then
        ---@type string
        local line = vim.api.nvim_get_current_line()
        local before, selection, after = line:cut_out(start_col, end_col)
        vim.api.nvim_set_current_line(before .. input .. selection .. input:fancy_reverse() .. after)
    else
        print("todo")
    end
    qwox_util.enter_normal_mode() -- alternative: move/expand selection
end, { desc = "[S]urround selection" })

--#endregion surround

--#region Git keymaps

vim.keymap.set("n", "<leader>gg", vim.cmd.Git, { desc = "[G]it: open menu" })
vim.keymap.set("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "[G]it: [S]tatus" })
vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches, { desc = "[G]it: [B]ranches" })
vim.keymap.set("n", "<leader>gf", ":Git fetch<CR>", { desc = "[G]it: [F]etch" })
vim.keymap.set("n", "<leader>gd", ":Git pull<CR>", { desc = "[G]it: Pull [D]own" })
vim.keymap.set("n", "<leader>gu", ":Git push<CR>", { desc = "[G]it: Push [U]p" })
vim.keymap.set("n", "<leader>gy", ":Git fetch<CR>:Git pull<CR>:Git push<CR>", {
    desc = "[G]it: s[Y]nc (fetch, pull, push)"
})

vim.keymap.set("n", "<leader>gaa", ":!git add -A<CR>", { desc = "[G]it: [A]dd [A]ll" })
--vim.keymap.set("n", "<leader>ga", require("telescope.builtin").git_stash, { desc = "[G]it: [A]dd" })

--#endregion Git keymaps
