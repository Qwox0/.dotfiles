local function config()
    local ls = require("luasnip")

    local function is_active()
        return ls.session.current_nodes[vim.api.nvim_get_current_buf()] ~= nil
    end

    ls.setup {
        update_events = 'TextChanged,TextChangedI',
    }
    require("luasnip.loaders.from_lua").load { paths = "./snippets" }

    vim.keymap.set({ "i", --[[ "n" ]] }, "<Tab>", function()
        if ls.locally_jumpable(1) then
            --ls.jump(1) -- doesn't work with `expr = true`
            return "<Plug>luasnip-jump-next" -- doesn't work in normal mode
        else
            return "<Tab>"
        end
    end, { silent = true, expr = true })

    --vim.autocmd.new("InsertLeave", { callback = function() ls.unlink_current() end })
    vim.autocmd.new("InsertLeave", {
        callback = function()
            if is_active() then
                print("luasnip unlink")
                ls.unlink_current()
            end
        end
    })
end

return {
    "L3MON4D3/LuaSnip",
    config = config,
}
