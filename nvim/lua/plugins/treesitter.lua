local function config()
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

    -- add parser for my programming language
    parser_configs["mylang"] = {
        install_info = {
            url = "~/src/tree-sitter-mylang",
            files = { "src/parser.c", "src/scanner.c" },
            branch = "main",               -- default branch in case of git repo if different from master
            generate_requires_npm = false, -- if stand-alone parser without npm dependencies
            requires_generate_from_grammar = false
        },
        filetype = "mylang",
    }

    -- use local markdown parser which fixes a segfault when injecting markdown into my `mylang` parser.
    local local_markdown_dir = require("qwox.util").paths.home .. "/src/tree-sitter-markdown"
    if vim.uv.fs_stat(local_markdown_dir) then
        local markdown_config = parser_configs.markdown
        markdown_config.install_info.url = local_markdown_dir
        parser_configs["markdown"] = markdown_config
    end

    require("nvim-treesitter.configs").setup {
        ensure_installed = { "vimdoc", "lua", "rust" },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "markdown", },
        },
        indent = {
            enable = false,
            disable = { "python", "cpp", "yaml" }
        },
        incremental_selection = {
            --[[
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
        },]]
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            --[[
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["] ]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        }, ]]
        },
        modules = {},
        ignore_install = {},
        custom_captures = {
            --["@variable.mutable"] = "@variable.mutable",
        },
    }
end

return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/playground",             -- show treesitter AST (for plugin development)
        "nvim-treesitter/nvim-treesitter-context" -- show current context (function) at the top
    },
    --build = ":TSUpdate",
    build = function()
        pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
    config = config,
}
