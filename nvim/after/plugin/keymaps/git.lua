-- git keymaps
local nnoremap = require("qwox.keymap").nnoremap
local telescope = require("telescope.builtin")

nnoremap("<leader>gi", function() telescope.git_status() end,       "git status (\"info\")")
nnoremap("<leader>gb", function() telescope.git_branches() end,     "git sshow branches")
nnoremap("<leader>gf", ":!git fetch<CR>",                           "git fetch")
nnoremap("<leader>gd", ":!git pull<CR>",                            "git pull (\"down\")")
nnoremap("<leader>gu", ":!git push<CR>",                            "git push (\"up\")")
nnoremap("<leader>ga", ":!git add -A<CR>",                          "git stash all")
nnoremap("<leader>gca", function ()
    local stage = vim.api.nvim_exec(":!git add -A", true) -- true: don't show output, return it!
    local status = vim.api.nvim_exec(":!git status", true) -- true: don't show output, return it!
    local msg = vim.fn.input(tostring(stage) .. tostring(status) .. "Commit Message > ")
    if msg == "q" or msg == "Q" then return end
    local commit_cmd = ":!git commit -m \"" .. msg .. "\""
    local ok = vim.fn.confirm("Execute " .. commit_cmd .. "?", "&Yes\n&No") -- Yes=1; No=2
    if ok == 2 then return end
    vim.api.nvim_exec(commit_cmd, false)
end,      "git commit all")

nnoremap("<leader>gs", ":!git fetch<CR>:!git pull<CR>:!git push<CR>", "git sync (fetch, pull, push)")
