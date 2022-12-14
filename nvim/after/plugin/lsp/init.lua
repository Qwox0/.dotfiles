-- for all available see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local qwox_lsp = require("qwox.lsp")

-- RUST
--[[ rust-analyzer in rustup toolchain
(see: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary)
$ rustup component add rust-analyzer

However, in contrast to component add clippy or component add rustfmt, this does not actually place a rust-analyzer binary in ~/.cargo/bin, see this issue. You can find the path to the binary using:
$ rustup which --toolchain stable rust-analyzer

You can link to there from ~/.cargo/bin or configure your editor to use the full path.

Alternatively you might be able to configure your editor to start rust-analyzer using the command:
$ rustup run stable rust-analyzer
]]
local rust_analyzer_cmd = { "rustup", "run", "stable", "rust-analyzer" }
--local rust_analyzer_cmd = { "rustup", "run", "nightly", "rust-analyzer" }
local has_rt, rt = pcall(require, "rust-tools")
if has_rt then
    rt.setup({
        server = qwox_lsp.get_config({
            cmd = rust_analyzer_cmd,
        }),
        tools = { -- rust-tools options
            inlay_hints = {
                show_parameter_hints = false,
                parameter_hints_prefix = "", --←
                other_hints_prefix = "» ",
                highlight = "Comment", -- The color of the hints
            },
            -- options same as lsp hover / vim.lsp.util.open_floating_preview()
            hover_actions = {
                -- see vim.api.nvim_open_win()
                border = {
                    { "╭", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╮", "FloatBorder" },
                    { "│", "FloatBorder" },
                    { "╯", "FloatBorder" },
                    { "─", "FloatBorder" },
                    { "╰", "FloatBorder" },
                    { "│", "FloatBorder" },
                },
                -- whether the hover action window gets automatically focused
                -- default: false
                auto_focus = false,
            },
        },
    })
else
    qwox_lsp.setup_server("rust_analyzer", {
        cmd = rust_analyzer_cmd,
        filetypes = { "rust" },
        --root_dir = vim.lsp.util.root_pattern("Cargo.toml", "rust-project.json"),
        settings = {
            ["rust-analyzer"] = {}
        },
    })
end

-- LUA
local sumneko_root_path = require("qwox.util").home .. "/dev/lib/sumneko-lua"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
if require("qwox.util").os.is_windows then
    sumneko_binary = sumneko_binary .. ".exe"
end

if require("qwox.util").file_exists(sumneko_binary) then
    qwox_lsp.setup_server("sumneko_lua", {
        cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT", -- Lua version (LuaJIT for Neovim)
                    path = vim.split(package.path, ";"), -- Setup your lua path
                },
                diagnostics = {
                    globals = { "vim" }, -- recognize the `vim` global
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                },
                telemetry = { enable = false, },
            },
        },
    })
end

-- HTML
qwox_lsp.setup_server("html", {
    cmd = { "html-languageserver", "--stdio" },
    filetypes = { "html" },
    settings = {},
})

-- Typescript
qwox_lsp.setup_server("tsserver", {
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" },
    root_dir = function() return vim.loop.cwd() end -- run lsp for javascript in any directory
})
--require'lspconfig'.tsserver.setup{}
