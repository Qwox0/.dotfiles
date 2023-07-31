-- define autocommand which are executed automatically in response to some event

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- skeletons
local f = io.popen("find " .. require("qwox.util").paths.nvim_config .. "/templates -mindepth 1")
if f ~= nil then
    for path in f:lines() do
        ---@type string
        local ext = path:sub0((path:rfind0("%.") or -1) + 1)
        autocmd("BufNewFile", { pattern = "*." .. ext, command = ":0r " .. path })
    end
end

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
