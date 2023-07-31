---@diagnostic disable: undefined-global
return {
    s("printdbg", {
        t("println!(\"{:?}\", "),
        i(1),
        t(" );")
    }),
    s("::Vec", t("::<Vec<_>>"))
}
