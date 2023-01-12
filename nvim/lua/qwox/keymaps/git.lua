-- git keymaps
local telescope = require("telescope.builtin")

local git_stash = function(opts)
    if type(opts) ~= "table" then opts = {} end
    return function()
        if opts.all == true then
            vim.api.nvim_exec(":!git add -A", true) -- true: don't show output, return it!
        else
            telescope.git_stash()
        end
    end
end

vim.keymap.set("n", "<leader>git", vim.cmd.Git)
vim.keymap.set("n", "<leader>gs", function() telescope.git_status() end)
vim.keymap.set("n", "<leader>gb", function() telescope.git_branches() end)
vim.keymap.set("n", "<leader>gf", ":!git fetch<CR>")
vim.keymap.set("n", "<leader>gd", ":!git pull<CR>")
vim.keymap.set("n", "<leader>gu", ":!git push<CR>")
vim.keymap.set("n", "<leader>gaa", ":!git add -A<CR>")
vim.keymap.set("n", "<leader>ga", git_stash({ all = false }))
vim.keymap.set("n", "<leader>gca", function()
    local stage = vim.api.nvim_exec(":!git add -A", true) -- true: don't show output, return it!
    local status = vim.api.nvim_exec(":!git status", true) -- true: don't show output, return it!
    local msg = vim.fn.input(tostring(stage) .. tostring(status) .. "Commit Message > ")
    if msg == "q" or msg == "Q" then return end
    local commit_cmd = ":!git commit -m \"" .. msg .. "\""
    local ok = vim.fn.confirm("Execute " .. commit_cmd .. "?", "&Yes\n&No") -- Yes=1; No=2
    if ok == 2 then return end
    vim.api.nvim_exec(commit_cmd, false)
end)

-- vim.keymap.set("n", "<leader>gs", ":!git fetch<CR>:!git pull<CR>:!git push<CR>", "git sync (fetch, pull, push)")
