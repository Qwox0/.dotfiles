local _ = {}

function _.setup_lsp()
    qwox.lsp.setup_server("mylang_ls", {
        cmd = { "mylang_ls" },
        filetypes = { "mylang" },
        --root_dir = vim.loop.cwd(),
        root_markers = { ".git" },
    })
end

function _.setup_filetype()
    vim.filetype.add({ extension = { mylang = "mylang" } })
end

return _
