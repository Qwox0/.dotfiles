-- on require("qwox.keymap") returns Mapper which can be used to define keymaps in vim style

local help_menu = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or { noremap = true, silent = true }
    return function(lhs, rhs, description, opts)
        if type(description) ~= "string" then description = "<missing>" end
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {})
        help_menu[tostring(op .. lhs)] = { op = op, lhs = lhs, rhs = rhs, opts = opts, description = description }
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

return {
    nmap = bind("n", { noremap = false }),
    nnoremap = bind("n"),
    vnoremap = bind("v"),
    xnoremap = bind("x"),
    inoremap = bind("i"),
    help_menu = help_menu,
}
