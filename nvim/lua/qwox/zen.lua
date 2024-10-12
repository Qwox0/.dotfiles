local zen
zen = {
    is_enabled = false,
    old_cmdheight = 0,
    old_signcolumn = "no",
    old_laststatus = 2,
    toggle = function()
        if zen.is_enabled then zen.disable() else zen.enable() end
    end,
    enable = function()
        if zen.is_enabled then
            vim.notify("zen mode is already enabled", "warn")
            return
        end
        require("qwox.numbers").disable()
        zen.old_cmdheight = vim.opt.cmdheight
        vim.opt.cmdheight = 0
        zen.old_signcolumn = vim.opt.signcolumn
        vim.opt.signcolumn = "no"
        zen.old_laststatus = vim.opt.laststatus
        vim.opt.laststatus = 0
        zen.is_enabled = true
    end,
    disable = function()
        if not zen.is_enabled then
            vim.notify("zen mode is already disabled", "warn")
            return
        end
        require("qwox.numbers").enable()
        vim.opt.cmdheight = zen.old_cmdheight
        vim.opt.signcolumn = zen.old_signcolumn
        vim.opt.laststatus = zen.old_laststatus
        zen.is_enabled = false
    end,

}
return zen
