-- colorschemes["scheme_name"] = scheme_setup
local colorschemes = {
    gruvbox = function()
        vim.g.gruvbox_contrast_dark = "hard"
    end,
    tokyonight = function()
        vim.g.tokyonight_transparent_sidebar = true
        vim.g.tokyonight_transparent = true
    end,
    ["rose-pine"] = function()
        require("rose-pine").setup({
            dark_variant = "moon",
        })
    end,
    catppuccin = function()
    end,
}


local set_scheme = function(scheme_name)
    local scheme_setup = colorschemes[scheme_name]
    if scheme_setup == nil then return "Err: invalid scheme_name" end

    vim.opt.background = "dark"

    scheme_setup()
    vim.cmd("colorscheme " .. scheme_name)

    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

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

    hl("Normal", {
        bg = "none"
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

set_scheme("gruvbox")
--set_scheme("rose-pine")

return {
    -- colorschemes = colorschemes,
    set_scheme = set_scheme,
}
