local U = {}

U.home = os.getenv("HOME")

U.paths = {
    configs = "~/.dotfiles", -- for nvim specific vim.fn.stdpath('config'),
    src = U.home .. "/dev/src"
}
--print(vim.fn.stdpath('config')) --test

local sysname = vim.loop.os_uname().sysname -- "Linux", "Windows_NT"
U.os = {
    is_windows = sysname == "Windows_NT",
    is_linux = sysname == "Linux",
}


local api = vim.api

U.file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else return false end
end

U.open_window = function(lines)
    local buf = api.nvim_create_buf(false, true) -- create new emtpy buffer

    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    -- get dimensions
    local width = api.nvim_get_option("columns")
    local height = api.nvim_get_option("lines")

    -- calculate our floating window size
    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)

    -- and its starting position
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    -- set some options
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col
    }

    -- and finally create it with buffer attached
    local win = api.nvim_open_win(buf, true, opts)
end
-- }}}

return U
