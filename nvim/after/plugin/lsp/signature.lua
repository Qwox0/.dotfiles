local ok, lsp_signature = pcall(require, "lsp_signature")
if not ok then print("Warn: lsp_signature is missing!"); return end

-- https://github.com/ray-x/lsp_signature.nvim
lsp_signature.setup({
    debug = false, -- set to true to enable debug logging
    log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
    verbose = false, -- show debug line number

    bind = true, -- This is mandatory, otherwise border config won"t get registered. If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated); set to 0 if you DO NOT want any API comments be shown
    -- only in insert mode, does not affect signature help in normal mode

    always_trigger = true, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
    timer_interval = 50, -- default timer check interval set to lower value if you want to reduce latency

    -- -- -- Floating Window
    floating_window = true, -- hint in floating window

    max_height = 1, -- max height of signature floating_window
    max_width = 999999, -- max_width of signature floating_window
    noice = false, -- set to true if you using noice to render markdown
    wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note: will set to true when fully tested, set to false will use whichever side has more space this setting will be helpful if you do not want the PUM and floating win overlap
    floating_window_off_x = 0, -- adjust float windows x position.
    floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
    close_timeout = 4000, -- close floating window after ms when laster parameter is entered
    fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters

    handler_opts = {
        border = "none" -- double, rounded, single, shadow, none
    },

    padding = " ", -- character to pad on left and right of signature
    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. "Green" or "#121315"
    zindex = 1000, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

    -- -- -- Virtual Text
    hint_enable = false, -- virtual hint enable
    hint_prefix = "🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
    hint_scheme = "String",
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight

    -- -- -- Other
    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = "<M-x>"
    select_signature_key = nil, -- cycle to next signature, e.g. "<M-n>" function overloading
    move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
})

