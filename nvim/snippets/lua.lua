---@diagnostic disable: undefined-global

require("typed.snip")

return {
    s("test", {
        t("this is a test! "),
        i(1),
        t(" more text (your input: "),
        f(function(args) return args[1][1] end, { 1 }),
        t(")")
    }),
}
