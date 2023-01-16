-- git keymaps
local telescope = require("telescope.builtin")

local map = function(mode, keys, func, desc)
    if desc then
        desc = "Git: " .. desc
    end
    vim.keymap.set(mode, keys, func, { desc = desc })
end

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

map("n", "<leader>git", vim.cmd.Git, "todo")
map("n", "<leader>gs", function() telescope.git_status() end, "[S]tatus")
map("n", "<leader>gb", function() telescope.git_branches() end, "[B]ranches")

map("n", "<leader>gf", ":!git fetch<CR>", "[F]etch")
map("n", "<leader>gd", ":!git pull<CR>", "Pull [D]own")
map("n", "<leader>gu", ":!git push<CR>", "Push [U]p")
map("n", "<leader>gy", ":!git fetch<CR>:!git pull<CR>:!git push<CR>", "s[Y]nc (fetch, pull, push)")

map("n", "<leader>gaa", ":!git add -A<CR>", "[A]dd [A]ll")
map("n", "<leader>ga", git_stash({ all = false }), "[A]dd")
map("n", "<leader>gca", function()
    local stage = vim.api.nvim_exec(":!git add -A", true) -- true: don't show output, return it!
    local status = vim.api.nvim_exec(":!git status", true) -- true: don't show output, return it!
    local msg = vim.fn.input(tostring(stage) .. tostring(status) .. "Commit Message > ")
    if msg == "q" or msg == "Q" then return end
    local commit_cmd = ":!git commit -m \"" .. msg .. "\""
    local ok = vim.fn.confirm("Execute " .. commit_cmd .. "?", "&Yes\n&No") -- Yes=1; No=2
    if ok == 2 then return end
    vim.api.nvim_exec(commit_cmd, false)
end, "[C]ommit [A]ll")
map("n", "<leader>gco", function()
    local status = vim.api.nvim_exec(":!git status", true) -- true: don't show output, return it!
    local msg = vim.fn.input(tostring(status) .. "Commit Message > ")
    if msg == "q" or msg == "Q" then return end
    local commit_cmd = ":!git commit -m \"" .. msg .. "\""
    local ok = vim.fn.confirm("Execute " .. commit_cmd .. "?", "&Yes\n&No") -- Yes=1; No=2
    if ok == 2 then return end
    vim.api.nvim_exec(commit_cmd, false)
end, "[CO]mmit")
