local _ = {}
qwox.compile_mode = _

_.augroup = vim.augroup.new("qwox.compile_mode", { clear = false })

function _.is_active() return not not vim.g.compile_command end

_.recompile_on_save_autocmd_id = nil
function _.recompile_on_save()
    if _.recompile_on_save_autocmd_id then
        vim.notify("`qwox.compile_mode.recompile_on_save` is already enabled", "error")
        return
    end
    _.recompile_on_save_autocmd_id =
        vim.autocmd.new('BufWritePost', {
            callback = require("compile-mode").recompile,
            group = _.augroup,
        })
end

function _.disable_recompile_on_save()
    if not _.recompile_on_save_autocmd_id then
        vim.notify("`qwox.compile_mode.recompile_on_save` is already disabled", "error")
        return
    end
    vim.autocmd.del(_.recompile_on_save_autocmd_id)
    _.recompile_on_save_autocmd_id = nil
end

--- copied from `compile-mode/errors/init.lua:405`
---@param bufnr integer
---@param error CompileModeError
---@return vim.Diagnostic
function _.map_to_diagnostic(bufnr, error)
    local l = require("compile-mode.errors").level

    ---@type vim.diagnostic.Severity
    local level
    if error.level == l.ERROR then
        level = vim.diagnostic.severity.ERROR
    elseif error.level == l.WARNING then
        level = vim.diagnostic.severity.ERROR
    else
        level = vim.diagnostic.severity.INFO
    end

    local col = error.col and error.col.value - 1 or 0
    local lnum = error.row.value - 1

    ---@type vim.Diagnostic
    return {
        bufnr = bufnr,
        col = col,
        lnum = lnum,
        message = error.full_text,
        severity = level,
        end_col = error.end_col and error.end_col.value - 1 or col,
        end_lnum = error.end_row and error.end_row.value - 1 or lnum,
    }
end

function _.find_errors()
    if not _.is_active() then
        require("compile-mode").compile()
    end
    require("compile-mode.extensions.telescope")()
end

return {
    "ej-shafran/compile-mode.nvim",
    version = "^5.0.0",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "m00qek/baleia.nvim",

        "nvim-telescope/telescope.nvim",
    },
    cmd = { "Compile", "Recompile" },
    keys = {
        { "<leader>fc", _.find_errors, desc = "[F]ind [C]ompile mode errors" }
    },
    config = function()
        ---@type CompileModeOpts
        vim.g.compile_mode = {
            default_command = {
                mylang = "mylang run %",
            },

            -- if you use something like `nvim-cmp` or `blink.cmp` for completion,
            -- set this to fix tab completion in command mode:
            input_word_completion = true,

            -- ANSI escape code support
            baleia_setup = {
                --strip_ansi_codes = false,
            },

            -- to make `:Compile` replace special characters (e.g. `%`) in
            -- the command (and behave more like `:!`), add:
            bang_expansion = true,

            error_regexp_table = {
                rust_panic = {
                    regex = "^thread '[^']*' ([0-9]*) panicked at \\([^:]\\+\\):\\([0-9]\\+\\):\\([0-9]\\+\\)",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                rust_compiler_diagnostic = {
                    -- TODO: implement multiline regex and highlights (see compile-mode/utils.lua > add_highlight, compile-mode/init.lua > _parse_errors)
                    --regex = "^\\(\\(warning\\)\\|\\(error\\)\\)\\(\\[E\\d*\\]\\)\\?:[^\n]*\n[ ]*--> \\([^:\n]\\+\\):\\([0-9]\\+\\):\\([0-9]\\+\\)$",
                    regex = "^[ ]*--> \\([^:\n]\\+\\):\\([0-9]\\+\\):\\([0-9]\\+\\)",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
            },

            --use_diagnostics = { keep_window = true, },
            --hidden_buffer = true,

            --use_pseudo_terminal = true,
        }

        vim.colors.del("CompileModeCommandOutput")
        vim.colors.link("CompileModeError", "DiagnosticError")
        vim.colors.link("CompileModeWarning", "DiagnosticWarn")

        vim.command.set("RecompileOnSave", _.recompile_on_save)
        vim.command.set("DisableRecompileOnSave", _.disable_recompile_on_save)

        vim.autocmd.new("User", {
            pattern = "CompilationFinished",
            callback = function()
                local errors = require("compile-mode.errors")
                local diagnostics_per_buf = vim.iter(vim.tbl_values(errors.error_list))
                    :fold({}, function(acc, error)
                        local error_buf = vim.fn.bufadd(error.filename.value)
                        acc[error_buf] = acc[error_buf] or {}
                        table.insert(acc[error_buf], _.map_to_diagnostic(error_buf, error))
                        return acc
                    end)

                local compile_mode_ns = vim.api.nvim_create_namespace("compile-mode.nvim")
                for buf, diagnostics in pairs(diagnostics_per_buf) do
                    vim.diagnostic.set(compile_mode_ns, buf, diagnostics, {})
                end
            end,
            group = _.augroup,
        })
    end
}
