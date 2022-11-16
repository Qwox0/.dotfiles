local colorschemes = {
    gruvbox = {
        name = "gruvbox",
        setup = function()
            vim.g.gruvbox_contrast_dark = "hard"
        end,
    },
    tokyonight = {
        name = "tokyonight",
        setup = function()
            vim.g.tokyonight_transparent_sidebar = true
            vim.g.tokyonight_transparent = true
        end,
    },
    ["rose-pine"] = {
        name = "rose-pine",
        setup = function()
            require('rose-pine').setup({
                dark_variant = 'moon',
            })

        end
    },
    catppuccin = {
        name = "catppuccin",
        setup = function()

        end
    },
}


local set_scheme = function(scheme)
    vim.opt.background = "dark"

    scheme.setup()
    vim.cmd("colorscheme " .. scheme.name)

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
end

set_scheme(colorschemes.gruvbox)
--set_scheme(colorschemes["rose-pine"])

return {
    colorschemes = colorschemes,
    set_scheme = set_scheme,
}
