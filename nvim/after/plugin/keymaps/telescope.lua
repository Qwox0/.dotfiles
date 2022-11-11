local nnoremap = require("qwox.keymap").nnoremap
local telescope = require("telescope.builtin")
local find_opts = { hidden = true }
if vim.fn.has('windows')  then find_opts = {} end

nnoremap("<leader>ff", function() telescope.find_files(find_opts) end,   "search for file")
nnoremap("<leader>fg", function() telescope.live_grep() end,             "search for file content")
nnoremap("<leader>fs", function() telescope.grep_string({ search = vim.fn.input("Grep For > ")}) end, "search for file with specific string")

nnoremap("<leader>fb", function() telescope.buffers() end,               "search for buffer")
nnoremap("<leader>fh", function() telescope.help_tags() end,             "search for help")
