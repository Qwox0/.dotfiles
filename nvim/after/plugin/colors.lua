local mycolors = require("qwox.mycolors")
local colors = require("typed.colors")

local colorschemes = {
    gruvbox = {
        name = "gruvbox",
        setup = function()
            vim.g.gruvbox_contrast_dark = "hard"

            for _, color in ipairs({ "Red", "Yellow", "Green", "Orange", "Blue", "Aqua" }) do
                colors.update_hl("Gruvbox" .. color .. "Sign", { bg = "none" })
            end
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

mycolors.set_scheme(colorschemes.gruvbox)

-- setup norcalli/nvim-colorizer.lua
if not require("qwox.util").has_plugins("colorizer") then return end

require("colorizer").setup({ "*" }, {
    RGB      = true,         -- #RGB hex codes
    RRGGBB   = true,         -- #RRGGBB hex codes
    names    = true,         -- "Name" codes like Blue
    RRGGBBAA = true,         -- #RRGGBBAA hex codes
    rgb_fn   = true,         -- CSS rgb() and rgba() functions
    hsl_fn   = true,         -- CSS hsl() and hsla() functions
    css      = true,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn   = true,         -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode     = "background", -- Set the display mode. Available modes: foreground, background
})
