local AUTO = {}

-- Highlight on yank
vim.augroup.new("YankHighlight", { clear = true })
vim.autocmd.new("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = "100" }
    end
})

-- Remove whitespace on save
vim.autocmd.new("BufWritePre", { pattern = "*", command = ":%s/\\s\\+$//e" })

-- only highlight search results while in cmd
-- TODO: only highlight when in search mode ("/", "?") or don't highlight -> must work with `:s/` and searchcount!
vim.colors.link("CurSearch", "Search")
vim.autocmd.set("CmdlineEnter", {
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
    callback = function()
        vim.colors.del("Search")
    end,
})

local vimmode = vim.mode
---@type table<number, 0|1|2|3>
AUTO.buf_conceallevels = {}
vim.autocmd.new("ModeChanged", {
    pattern = table.arr_map(vimmode.vis_modes, function(vis) return "n:" .. vis end),
    callback = function(opts)
        ---@diagnostic disable-next-line: undefined-field
        AUTO.buf_conceallevels[opts.buf] = vim.opt_local.conceallevel._value or 0
        vim.opt_local.conceallevel = 0
    end,
})
vim.autocmd.new("ModeChanged", {
    pattern = table.arr_map(vimmode.vis_modes, function(vis) return vis .. ":n" end),
    callback = function(opts)
        vim.opt_local.conceallevel = AUTO.buf_conceallevels[opts.buf] or 0
    end,
})

vim.filetype.add {
    extension = {
        mylang = "mylang",
    },
}

return AUTO
