if not require("qwox.util").has_plugins("packer") then return end

return require("packer").startup(function(use)
    use { "wbthomason/packer.nvim" } -- Packer can manage itself

    --use { "nvim-lua/popup.nvim" } -- dependency
    --use { "mfussenegger/nvim-dap" } -- Debugging

    -- -- -- Telescope
    use { "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" }
    }
    use { "nvim-telescope/telescope-ui-select.nvim" }

    -- -- -- LSP
    use { "neovim/nvim-lspconfig",
        requires = {
            -- LSP Support
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Useful status UI for LSP
            "j-hui/fidget.nvim",

            -- little Symbols
            "onsails/lspkind-nvim",

            -- rust
            "simrat39/rust-tools.nvim"
        }
    }
    --use { "simrat39/rust-tools.nvim" } -- LSP: rust_analyzer
    use { "ray-x/lsp_signature.nvim" }

    -- -- -- CMP
    use { "hrsh7th/nvim-cmp",
        requires = {
            -- completiion sources
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-cmdline",
            {
                "saecki/crates.nvim",
                requires = { "nvim-lua/plenary.nvim" },
                config = function() require("crates").setup() end,
            },

            -- Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        }
    }

    -- -- -- Harpoon
    use { "theprimeagen/harpoon" }
    use { "ThePrimeagen/vim-be-good" }

    -- Treesitter: Syntax highlighting (see after/plugins/treesitter.lua
    use { "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update({ with_sync = true }))
        end,
    }
    use { "nvim-treesitter/playground" }     -- show treesitter AST (for plugin development)
    use { "romgrk/nvim-treesitter-context" } -- show current context (function) at the top

    use { "norcalli/nvim-colorizer.lua" }    -- highlight color codes

    -- Undotree
    use { "mbbill/undotree" }

    -- Git
    use { "tpope/vim-fugitive" }

    --use { "terryma/vim-multiple-cursors" } -- CTRL + N for new cursor
    use { "tpope/vim-surround" } -- ds": "word" -> word | cs"(: "word" -> ( word )
    --use { "jiangmiao/auto-pairs" }
    use { "windwp/nvim-autopairs" }


    --[[ Style ]]
    use { "nvim-lualine/lualine.nvim", -- bottom statusline
        requires = "kyazdani42/nvim-web-devicons"
    }
    use { "akinsho/bufferline.nvim", -- show open buffers at the top
        requires = "kyazdani42/nvim-web-devicons"
    }


    --use { "lukas-reineke/indent-blankline.nvim" } -- show indentation
    --[[ Style ]]
    -- Themes
    use { "folke/tokyonight.nvim" }
    use { "gruvbox-community/gruvbox" }
    use { "catppuccin/nvim", as = "catppuccin" }
    use { "rose-pine/neovim", as = "rose-pine" }
end)
