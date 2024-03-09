local autocmd = require("typed.autocmd")
local augroup = require("typed.augroup")

-- no relative line numbers in Insert mode
autocmd("InsertEnter", { command = ":set norelativenumber" })
autocmd("InsertLeave", { command = ":set relativenumber" })

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = "100" }
    end
})

-- Remove whitespace on save
autocmd("BufWritePre", { pattern = "*", command = ":%s/\\s\\+$//e" })

-- only highlight search results while in cmd
-- TODO: only highlight when in search mode ("/", "?") or don't highlight -> must work with `:s/` and searchcount!
require("typed.colors").link_hl("CurSearch", "Search")
autocmd("CmdlineEnter", {
    callback = function()
        require("typed.colors").set_hl("Search", {
            reverse = true,
            bg = 2631720,  -- #282828
            fg = 16432431, -- #fabd2f
            cterm = { reverse = true },
            ctermbg = 235,
            ctermfg = 214,
        })
    end
})
autocmd("CmdlineLeave", {
    callback = function()
        require("typed.colors").clear_hl("Search")
    end,
})
