local U = {}

local home = vim.fn.expand("~")
local nvim_data = vim.fn.stdpath("data")
local mason = nvim_data .. "/mason"
local obsidian = home .. "/obsidian"

U.paths = {
    home = home,
    dotfiles = home .. "/.dotfiles",
    nvim_config = vim.fn.stdpath("config"),
    nvim_data = nvim_data,
    src = home .. "/src",
    lazy = nvim_data .. "/lazy/lazy.nvim",
    packer = nvim_data .. "/site/pack/packer/start/packer.nvim",
    mason = mason,
    mason_packages = mason .. "/packages",
    obsidian = vim.loop.fs_realpath(obsidian) or obsidian,
}

local sysname = vim.loop.os_uname().sysname -- "Linux", "Windows_NT"
U.os = {
    is_windows = sysname:find("Windows") and true or false,
    is_linux = sysname == "Linux",
}

function U.open_window(lines)
    local api = vim.api
    local buf = api.nvim_create_buf(false, true) -- create new emtpy buffer

    api.nvim_buf_set_option(buf, "bufhidden", "wipe")
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

---@param ... string
---@return boolean
function U.has_plugins(...)
    local has_all = true
    for _, plugin in ipairs { ... } do
        if not pcall(require, plugin) then
            vim.notify("WARN: " .. plugin .. " is missing!", "warn")
            has_all = false
        end
    end
    return has_all
end

U.file = {}

---@param path string
---@return boolean
function U.file.exists(path)
    local _, error = vim.loop.fs_stat(path)
    return error == nil
end

---returns the path of the current buffer.
---@return string
function U.get_buf_path()
    return vim.api.nvim_buf_get_name(0)
end

---Checks if the current filetype matches one of the arguments.
---@param ... string -
---@return boolean
function U.is_filetype(...)
    for _, filetype in ipairs { ... } do
        if vim.bo.filetype == filetype then return true end
    end
    return false
end

---@param o any
---@return string
function U.dump(o)
    return vim.inspect(o)
end

---@param o any
---@return string
function U.dump_old(o)
    if type(o) ~= "table" then return tostring(o) end
    local s = "{ "
    for k, v in pairs(o) do
        if type(k) ~= "number" then k = '"' .. k .. '"' end
        if type(v) == "string" then v = '"' .. v .. '"' end
        s = s .. "[" .. k .. "] = " .. U.dump(v) .. ", "
    end
    return s .. "}"
end

--#region edit text

---Get content of line `linenum` or the current line as a string.
---@param linenum integer|nil 1-indexed
---@return string
function U.get_line(linenum)
    if linenum == nil then return vim.api.nvim_get_current_line() end
    return vim.fn.getline(linenum)
end

---Set content of line `linenum` or the current line.
---@param linenum integer|nil 1-indexed
---@param text string
function U.set_line(linenum, text)
    if linenum == nil then
        vim.api.nvim_set_current_line(text)
    else
        vim.fn.setline(linenum, text)
    end
end

---Get position of the cursor
---@return integer row 1-indexed
---@return integer col 0-indexed
function U.get_cursor_pos()
    return table.unpack(vim.api.nvim_win_get_cursor(0))
end

---Get position of the word under the current cursor
---@return integer word_start 0-indexed; inclusive
---@return integer word_end 0-indexed; exclusive
function U.get_cursor_word_pos()
    local _, col = U.get_cursor_pos()
    local line = U.get_line()
    return line:get_word_pos(col)
end

---Get current line split around word under cursor.
---@return string before
---@return string word
---@return string after
function U.get_cursor_word()
    ---@type string
    local line = U.get_line()
    local word_start, word_end = U.get_cursor_word_pos()
    return line:multi_split(word_start, word_end)
end

---Get position of the selected area in visual mode
---start is inclusive, end is inclusive
---@return integer start_row 1-indexed
---@return integer start_col 0-indexed
---@return integer end_row 1-indexed
---@return integer end_col 0-indexed
function U.get_selection_pos()
    local row1, col1 = table.unpack(vim.fn.getpos('v'), 2, 3)
    local row2, col2 = table.unpack(vim.fn.getcurpos(), 2, 3)
    local start_row = math.min(row1, row2)
    local start_col = math.min(col1, col2)
    local end_row = math.max(row1, row2)
    local end_col = math.max(col1, col2)

    if U.is_visual_line_mode() then
        start_col = 1
        end_col = U.get_line(end_row):len()
    end

    return start_row, start_col, end_row, end_col
end

---Get selected text in visual mode
---start is inclusive, end is inclusive
function U.get_selection_text()
    local start_row, start_col, end_row, end_col = U.get_selection_pos()
    local n_lines = math.abs(end_row - start_row) + 1
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    lines[1] = string.sub(lines[1], start_col, -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, end_col - start_col + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, end_col)
    end
    return table.concat(lines, '\n')
end

---@return boolean
function U.is_visual_mode() return vim.fn.mode() == "v" end

---@return boolean
function U.is_visual_line_mode() return vim.fn.mode() == "V" end

---@return boolean
function U.is_visual_block_mode() return vim.fn.mode():byte() == 22 end

function U.enter_normal_mode()
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)
end

return U
