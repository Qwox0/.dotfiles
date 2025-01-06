local qwox_util = require("qwox.util")

vim.command.set("W", "w", { desc = "Prevent misspelling of :w" })
vim.command.set("Q", "q", { desc = "Prevent misspelling of :q" })
vim.command.set("Wa", "wa", { desc = "Prevent misspelling of :wa" })
vim.command.set("WA", "wa", { desc = "Prevent misspelling of :wa" })
vim.command.set("Wq", "wq", { desc = "Prevent misspelling of :wq" })
vim.command.set("WQ", "wq", { desc = "Prevent misspelling of :wq" })
vim.command.set("Wqa", "wqa", { desc = "Prevent misspelling of :wqa" })
vim.command.set("WQa", "wqa", { desc = "Prevent misspelling of :wqa" })

local function get_selected_text(command_args)
    return require("qwox.util").get_selection_text_of(command_args.line1, 0, command_args.line2, nil)
end

vim.command.set("Wordcount", function(arg)
    local text = get_selected_text(arg)
    print("Wordcount (split by whitespace):", text:wordcount(), " | Wordcount (human words):", text:humanwordcount())
end, { range = true, desc = "Count words (not whitespace) in current line" })
vim.command.set("WordcountNonWhitespace", function(arg)
    print("Wordcount (split by whitespace):", get_selected_text(arg):wordcount())
end, { range = true, desc = "Count words (not whitespace) in current line" })
vim.command.set("WordcountHuman", function(arg)
    print("Wordcount (human words):", get_selected_text(arg):humanwordcount())
end, { range = true, desc = "Count human words in current line" })

vim.command.set("ReverseLine", function()
    qwox_util.set_line(nil, qwox_util.get_line():reverse())
end, { desc = "Count human words in selection" })

vim.command.set("Zen", function() require("qwox.zen").toggle() end, { desc = "Toggle zen mode" })
