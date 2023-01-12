vim.g.mapleader = " " -- keymapping: define <leader> for mappings
vim.opt.timeout = false -- keymapping: command timeout

vim.keymap.set("n", "k", "v:count == 0 ? \"gk\" : \"k\"", { expr = true }, { desc = "jump up in wrapped lines" })
vim.keymap.set("n", "j", "v:count == 0 ? \"gj\" : \"j\"", { expr = true }, { desc = "jump down in wrapped lines" })

vim.keymap.set("i", "<C-i>", "<Esc>I", { desc = "jump to line end" })
vim.keymap.set("i", "<C-a>", "<Esc>A", { desc = "jump to line start" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move entire line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move entire line up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "don't move cursor on J" })

-- center cursor on some movements
-- zv: some extra folding stuff
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "" })
vim.keymap.set("n", "n", "nzzzv", { desc = "" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "" })

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "explore with vim file manager" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Ctrl+C = Esc" })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "paste but keep copy buffer" })

-- Substitute / Replace
vim.keymap.set("n", "<leader>ra", function()
    local search = vim.fn.input("Find > ") --TODO: highlight searched text
    vim.api.nvim_command("/" .. search)
    local replacement = vim.fn.input("Replace with > ")
    vim.api.nvim_command(":%s/" .. search .. "/" .. replacement .. "/g")
end, { desc = "[R]eplace [A]ll" })
vim.keymap.set("n", "<leader>rw", [[:%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[R]eplace [W]ord" })

-- -- -- buffer, window, tab
--[[ Explanation
    A buffer is the in-memory text of a file.   file
    A window is a viewport on a buffer.         buffer view
    A tab page is a collection of windows.      window collection]]

vim.keymap.set("n", "<leader>b", ":bprevious<CR>",
    { desc = "previous buffer ([B]ack)" })
vim.keymap.set("n", "<leader>n", ":bnext<CR>", { desc = "[N]ext buffer" })
-- close buffer
--vim.keymap.set("n", "<leader>q", ":bp<CR>:bd #<CR>", { desc = "" })
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "[Q]uit buffer" })
vim.keymap.set("n", "<leader>!q", ":bdelete!<CR>", { desc = "[Q]uit buffer[!]" })

-- switch between screens
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "switch screen left" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "switch screen down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "switch screen up" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "switch screen right" })

require("qwox.keymaps.git")