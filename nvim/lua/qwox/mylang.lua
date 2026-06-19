local _ = {}

_.LSP_DISABLED = true

function _.setup_lsp()
    if _.LSP_DISABLED then return end
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
