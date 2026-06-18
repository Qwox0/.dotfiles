local C = {}

C.terminal_theme_file_path = qwox.paths.dotfiles .. "/kitty/current-theme.conf"

function C.fetch_terminal_colors()
    local theme_file = io.open(C.terminal_theme_file_path, "r")
    if not theme_file then return nil end

    local terminal_colors = {}
    for color_code, color_hex in theme_file:read("*a"):gmatch("color(%d+)%s+(#%x+)") do
        terminal_colors[tonumber(color_code)] = color_hex
    end

    io.close(theme_file)
    return terminal_colors
end

C.terminal_colors = C.fetch_terminal_colors()

return C
