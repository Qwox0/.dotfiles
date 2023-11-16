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
}
