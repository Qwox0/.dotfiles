local function config()
    require("luasnip").setup {}
    require("luasnip.loaders.from_lua").load { paths = "./snippets" }
end

return {
    "L3MON4D3/LuaSnip",
    config = config,
}
