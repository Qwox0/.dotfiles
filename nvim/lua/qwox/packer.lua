-- config file for nvim package manager("packer")
-- This file can be loaded by calling `require"packer"` from your init.lua

-- Install added packages with :PackerSync

local has_packer, packer = pcall(require, "packer")
if not has_packer then return end

return packer.startup(function(use)
    use("wbthomason/packer.nvim")       -- Packer can manage itself
    use("nvim-lua/popup.nvim")          -- dependency
    use("nvim-lua/plenary.nvim")        -- dependency
    use("L3MON4D3/LuaSnip")             -- Snippet engine
    use("mfussenegger/nvim-dap")        -- Debugging

    -- -- -- Fuzzy Finder
    use("nvim-telescope/telescope.nvim")

    -- -- -- LSP
    use("neovim/nvim-lspconfig")        -- LSP: Install language: install language server > add language server to "after/plugins/lsp.lua")
    use("onsails/lspkind-nvim")         -- LSP: nice formating + icons
    use("simrat39/rust-tools.nvim")     -- LSP: rust_analyzer
    use("ray-x/lsp_signature.nvim")

    -- -- -- CMP
    use("hrsh7th/nvim-cmp")             -- suggestions/auto completions plugin
    use("hrsh7th/cmp-buffer")           -- suggestions from current buffer (file)
    use("hrsh7th/cmp-path")             -- suggest paths
    use("hrsh7th/cmp-nvim-lua")         -- lua + nvim suggestions
    use("hrsh7th/cmp-nvim-lsp")         -- compatibility with buildin LSP
    use("hrsh7th/cmp-cmdline")          -- vim cmdline completion
    use("saadparwaiz1/cmp_luasnip")     -- "L3MON4D3/LuaSnip" compatibility
    use { "saecki/crates.nvim",
        tag = "v0.3.0",
        requires = { "nvim-lua/plenary.nvim" },
        config = function() require("crates").setup() end,
    }

    -- Treesitter: Syntax highlighting (see after/plugins/treesitter.lua
    use({ "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    })
    --use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")   -- show current context (function) at the top

    use("terryma/vim-multiple-cursors")     -- CTRL + N for new cursor
    use("tpope/vim-surround")               -- ds": "word" -> word | cs"(: "word" -> ( word )
    use("jiangmiao/auto-pairs")
    --use("lukas-reineke/indent-blankline.nvim")-- show indentation

    use("ThePrimeagen/vim-be-good")         -- train vim movements with :VimBeGood5

    --[[ Style ]]
    use({ "nvim-lualine/lualine.nvim",       -- bottom statusline
        requires = "kyazdani42/nvim-web-devicons"
    })
    use({ "akinsho/bufferline.nvim",         -- show open buffers at the top
        tag = "v2.*",
        requires = "kyazdani42/nvim-web-devicons"
    })



    --[[ Style ]]
    -- Themes
    use("folke/tokyonight.nvim")
    use("gruvbox-community/gruvbox")
    use({ "catppuccin/nvim", as = "catppuccin" })
    use({ "rose-pine/neovim", as = "rose-pine" })

    -- Icons
    use("kyazdani42/nvim-web-devicons")
end)
