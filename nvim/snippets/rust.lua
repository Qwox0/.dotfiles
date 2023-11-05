---@diagnostic disable: undefined-global

require("qwox.snip")

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
