---@diagnostic disable: undefined-global

require("typed.snip")

return {
    s("main", {
        t {
            "std :: #import \"std\";",
            "",
            "main :: -> {",
            "    std.println(\"Hello World\");",
            "}",
        },
    }),
    s("printvar", {
        t("libc.printf(\""),
        f(function(args) return args[1][1] end, { 1 }),
        t(" = %"),
        i(2),
        t("\\n\".ptr, "),
        i(1),
        t(");"),
    }),
    s("std", { t("libc :: #import \"std\";") }),
    s("libc", { t("libc :: #import \"libc\";") }),
}
