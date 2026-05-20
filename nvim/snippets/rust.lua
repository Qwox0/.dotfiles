---@diagnostic disable: undefined-global

require("typed.snip")

return {
    s("printdbg", {
        t("println!(\"{:?}\", "),
        i(1),
        t(" );"),
    }),
    s("::Vec", t("::<Vec<_>>")),
    s("main", {
        t {
            "fn main() {",
            "    println!(\"Hello, world!\");",
            "}"
        },
    }),
    s("printvar", {
        t("println!(\""),
        f(function(args) return args[1][1] end, { 1 }),
        t(" = {}\", "),
        i(1),
        i(0),
        t(");"),
    }),
}
