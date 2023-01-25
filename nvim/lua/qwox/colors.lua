local default_scheme = "gruvbox"
local default_setup = function() end

local set_scheme = function(scheme)
    if type(scheme) == "string" then
        scheme = { name = scheme }
    end
    scheme.name = scheme.name or default_scheme
    scheme.setup = scheme.setup or default_setup

    local ok, _ = pcall(require, scheme.name)
    if not ok then print("Warn: " .. scheme.name .. " is missing!"); return end

    vim.cmd.colorscheme(scheme.name)

    scheme.setup()

    vim.opt.background = "dark"

    local hl = function(thing, opts)
        -- 0: global space (for every window)
        vim.api.nvim_set_hl(0, thing, opts)
    end

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

    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#2B79A0",
    })

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
