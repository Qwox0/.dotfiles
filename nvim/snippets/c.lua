---@diagnostic disable: undefined-global

require("typed.snip")

return {
    s("main", {
        t {
            "#include <stdio.h>",
            "",
            "int main(void) {",
            "    printf(\"Hello, world!\\n\");",
            "    return 0;",
            "}"
        },
    }),
    s("printvar", {
        t("printf(\""),
        f(function(args) return args[1][1] end, { 1 }),
        t(" = %"),
        i(2),
        t("\\n\", "),
        i(1),
        t(");"),
    }),
}
