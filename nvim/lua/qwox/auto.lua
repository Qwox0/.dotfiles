local autocmd = require("qwox.autocmd")
local augroup = require("qwox.augroup")

-- no relative line numbers in Insert mode
autocmd("InsertEnter", { pattern = "*", command = ":set norelativenumber" })
autocmd("InsertLeave", { pattern = "*", command = ":set relativenumber" })

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "100" })
    end
})

-- Remove whitespace on save
autocmd("BufWritePre", { pattern = "*", command = ":%s/\\s\\+$//e" })
