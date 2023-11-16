---@diagnostic disable: undefined-global

require("typed.snip")

return {
    s("iferr", {
        t {
            "if err != nil {",
            "	",
        },
        i(1),
        t { "}" },
    }),
}
