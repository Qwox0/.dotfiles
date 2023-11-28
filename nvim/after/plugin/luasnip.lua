if not require("qwox.util").has_plugins("luasnip") then return end

require("luasnip").setup {}
require("luasnip.loaders.from_lua").load { paths = "./snippets" }
