local _ = {}

vim.opt.hlsearch = false

_.group = vim.augroup.new("ToggleHlSearch", {})

function _.enable()
    vim.opt.hlsearch = true
    -- _.disable_on_move()
end

function _.disable()
    vim.opt.hlsearch = false
end

--[[
--- see <https://github.com/neovim/neovim/discussions/31495>
--- doesn't work
function _.disable_on_move()
    _.disable_on_move_group = vim.augroup.new("DisableHlSearchOnMove", { clear = true })
    --[[
    vim.autocmd.new("CursorMoved", {
        group = _.disable_on_move_group,
        callback = _.disable,
    })
    ] ]
    pcall(vim.autocmd.del, _.disable_on_move_autocmd)
    _.disable_on_move_autocmd = vim.autocmd.new("CursorMoved", {
        callback = _.disable,
        once = true
    })
end
]]

vim.autocmd.new("CmdlineEnter", {
    group = _.group,
    pattern = { "/", "?" },
    callback = _.enable,
})

---@param cmd string
---@return boolean
local function is_substitute_cmd(cmd)
    local cmdchar = cmd:match("^[.$%%]?(.)")
    if cmdchar == "s" or cmdchar == "&" then return true end
    cmdchar = cmd:match("^%d*(.)")
    return cmdchar == "s" or cmdchar == "&"
end

vim.autocmd.new({ "CmdlineChanged", "CmdlineEnter" }, {
    group = _.group,
    pattern = ":",
    callback = function() vim.opt.hlsearch = is_substitute_cmd(vim.fn.getcmdline()) end,
})

vim.autocmd.new("CmdlineLeave", {
    group = _.group,
    pattern = ":",
    callback = _.disable,
})

--[[
vim.autocmd.set("BufWrite", {
    group = toggle_hlsearch_group,
    callback = function() vim.opt.hlsearch = false end,
})
]]

-- only highlight search results while in cmd
-- TODO: only highlight when in search mode ("/", "?") or don't highlight -> must work with `:s/` and searchcount!
--[[
vim.colors.link("CurSearch", "Search")
vim.autocmd.set("CmdlineEnter", {
    group = toggle_hlsearch_group,
    callback = function()
        vim.colors.set("Search", {
            reverse = true,
            bg = 2631720,  -- #282828
            fg = 16432431, -- #fabd2f
            cterm = { reverse = true },
            ctermbg = 235,
            ctermfg = 214,
        })
    end
})
vim.autocmd.set("CmdlineLeave", {
    group = toggle_hlsearch_group,
    callback = function()
        vim.colors.del("Search")
    end,
})
]]

vim.colors.link("CurSearch", "IncSearch")

return _
