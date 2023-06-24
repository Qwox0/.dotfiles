local U = {}

U.home = os.getenv("HOME")

U.paths = {
    configs = "~/.dotfiles", -- for nvim specific vim.fn.stdpath("config"),
    src = U.home .. "/dev/src"
}
--print(vim.fn.stdpath("config")) --test

local sysname = vim.loop.os_uname().sysname -- "Linux", "Windows_NT"
U.os = {
    is_windows = sysname:find("Windows") and true or false,
    is_linux = sysname == "Linux",
}

local api = vim.api

function U.file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function U.open_window(lines)
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

-- set highlight groups
local own_hl = {};
function U.set_hl(name, opts)
    -- 0: global space (for every window)
    vim.api.nvim_set_hl(0, name, opts)
    own_hl[name] = opts
end

function U.get_own_hl() return own_hl end

---@param ... string
---@return boolean
function U.has_plugins(...)
    local has_all = true
    for _, plugin in ipairs { ... } do
        if not pcall(require, plugin) then
            print("Warn: " .. plugin .. " is missing!")
            has_all = false
        end
    end
    return has_all
end

---@param filetype string
---@return boolean
function U.is_filetype(filetype) return vim.bo.filetype == filetype end

---@param o any
---@return string
function U.dump(o)
    if type(o) ~= "table" then return tostring(o) end
    local s = "{ "
    for k, v in pairs(o) do
        if type(k) ~= "number" then k = '"' .. k .. '"' end
        if type(v) == "string" then v = '"' .. v .. '"' end
        s = s .. "[" .. k .. "] = " .. U.dump(v) .. ", "
    end
    return s .. "}"
end

return U
