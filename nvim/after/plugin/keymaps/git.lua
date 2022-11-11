-- git keymaps
local nnoremap = require("qwox.keymap").nnoremap

nnoremap("<leader>gi", ":!git status<CR>",  "git status (\"info\")")
nnoremap("<leader>gf", ":!git fetch<CR>",   "git fetch")
nnoremap("<leader>gu", ":!git push<CR>",    "git push (\"up\")")
nnoremap("<leader>gd", ":!git pull<CR>",    "git pull (\"down\")")
nnoremap("<leader>ga", ":!git add -A<CR>",  "git stash all")
nnoremap("<leader>gc", function ()
    local status = vim.api.nvim_exec(":!git status", true) -- true: don't show output, return it!
    local msg = vim.fn.input(tostring(status) .. "Commit Message > ")
    if msg == "q" then return end
    local commit_cmd = ":!git commit -m \"" .. msg .. "\""
    local ok = vim.fn.input("Execute \"" .. commit_cmd .. "\"? > ")
    if ok == "y" then
        local b = vim.api.nvim_exec(":echo \"hi\"", true)
        vim.fn.input("\n" ..b) --TODO
    end
end,      "git commit")
nnoremap("<leader>gs", ":!git fetch<CR>:!git pull<CR>:!git push<CR>", "git sync (fetch, pull, push)")

nnoremap("<leader>jj", ":echo \"a<BR>b\"<CR>")
