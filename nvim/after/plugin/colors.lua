local colors = require("qwox.colors")

local colorschemes = {
    gruvbox = {
        name = "gruvbox",
        setup = function()
            vim.g.gruvbox_contrast_dark = "hard"
        end
    },
    tokyonight = {
        name = "tokyonight",
        setup = function()
            vim.g.tokyonight_transparent_sidebar = true
            vim.g.tokyonight_transparent = true
        end
    },
    ["rose-pine"] = {
        name = "rose-pine",
        setup = function()
            require("rose-pine").setup({
                dark_variant = "moon",
            })
        end
    },
    catppuccin = {
        name = "catppuccin",
        setup = function()
        end
    },
}

--colors.set_scheme("gruvbox")
colors.set_scheme(colorschemes.gruvbox)
