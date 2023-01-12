local ok, harpoon = pcall(require, "harpoon")
if not ok then print("Warn: harpoon is missing!"); return end

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", function() mark.add_file() end)
vim.keymap.set("n", "<C-e>", function() ui.toggle_quick_menu() end)

--vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end)
