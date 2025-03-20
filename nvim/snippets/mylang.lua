---@diagnostic disable: undefined-global

require("typed.snip")

return {
    s("main", {
        t {
            "std :: #import \"std\"",
            "",
            "main :: -> {",
            "    std.println(\"Hello World\");",
            "}",
        },
    }),
}
