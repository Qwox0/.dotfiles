local _ = {}

function _.setup_lsp()
    local qwox_lsp = require("qwox.lsp")

    vim.lsp.set_log_level 'debug'
    qwox_lsp.setup_server("mylang_ls", {
        cmd = { "mylang_ls" },
        filetypes = { "mylang" },
        --root_dir = vim.loop.cwd(),
        root_markers = { ".git" },
    })
end

return _
