local default_scheme = "gruvbox"

local set_scheme = function(scheme)
    if type(scheme) == "string" then scheme = { name = scheme } end
    scheme.name = scheme.name or default_scheme
    scheme.setup = scheme.setup or function()
    end

    vim.cmd.colorscheme(scheme.name)
    scheme.setup()

    vim.opt.background = "dark"

    local hl = require("qwox.util").hl.set

    -- type :highlight to show highlight groups

    hl("Normal", {
        bg = "none"
    })

    --[[
    hl("NormalFloat", {
        bg = "none"
    })
    ]]
    hl("SignColumn", {
        bg = "none",
    })

    --[[
    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#fb4934",
        --link = "GruvboxRedSign",
    })
    ]]

    hl("CursorLineNR", {
        bg = "None"
    })

    --[[
    hl("LineNr", {
        fg = "#5eacd3"
    })

    hl("netrwDir", {
        fg = "#5eacd3"
    })
    ]]
    return "Ok"
end


return {
    -- colorschemes = colorschemes,
    set_scheme = set_scheme,
}
