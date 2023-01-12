local ok, bufferline = pcall(require, "bufferline")
if not ok then print("Warn: bufferline is missing!"); return end

bufferline.setup({
    options = {
        diagnostic = "nvim_lsp",
        diagnostic_update_in_insert = true,
        show_buffer_close_icons = false,    -- x on buffer
        show_buffer_default_icon = false,   -- whether or not an unrecognised filetype should show a default icon
        show_close_icon = false,            -- x on bufferline
    },
})
