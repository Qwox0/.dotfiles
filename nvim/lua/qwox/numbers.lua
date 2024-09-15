local numbers
numbers = {
    default = function() numbers.enable() end,
    enable = function()
        vim.opt.number = true
        vim.opt.relativenumber = true
        numbers.relativenumber_autocmds.enable()
    end,
    disable = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
        numbers.relativenumber_autocmds.disable()
    end,
    toggle = function()
        local is_enabled = vim.opt.number or vim.opt.relativenumber
        if is_enabled then numbers.disable() else numbers.enable() end
    end,
    relativenumber_autocmds = {
        enter = nil,
        leave = nil,
        enable = function()
            if numbers.relativenumber_autocmds.enter or numbers.relativenumber_autocmds.leave then
                vim.notify("autocmds are already enabled", "error")
                return
            end
            numbers.relativenumber_autocmds.enter = vim.autocmd.set("InsertEnter", { command = ":set norelativenumber" })
            numbers.relativenumber_autocmds.leave = vim.autocmd.set("InsertLeave", { command = ":set relativenumber" })
        end,
        disable = function()
            if numbers.relativenumber_autocmds.enter then vim.autocmd.del(numbers.relativenumber_autocmds.enter) end
            if numbers.relativenumber_autocmds.leave then vim.autocmd.del(numbers.relativenumber_autocmds.leave) end
            numbers.relativenumber_autocmds.enter = nil
            numbers.relativenumber_autocmds.leave = nil
        end,
    },
}
return numbers
