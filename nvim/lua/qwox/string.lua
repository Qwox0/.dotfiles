local non_word_pattern = "[^%a%d_]"

--- get start and end of word under position `pos`
--- see `require("qwox.string")`
---@param string string
---@param pos integer
---@return integer word_start 0-indexed; inclusive
---@return integer word_end 0-indexed; exclusive
function string.get_word_pos(string, pos)
    local word_start = (string:sub0(0, pos):rfind0(non_word_pattern) or -1) + 1
    local word_end = string:sub0(pos):find0(non_word_pattern)
    word_end = word_end ~= nil and word_end + pos or string:len()
    return word_start, word_end
end

--- Get current line split around word under cursor.
---@param string string
---@param start integer 0-indexed; inclusive
---@param end_ integer 0-indexed; exclusive
---@return string before part before `start`
---@return string word part between start and `end_`
---@return string after part after `end_
function string.cut_out(string, start, end_)
    local before = string:sub0(0, start)
    local word = string:sub0(start, end_)
    local after = string:sub0(end_)
    return before, word, after
end

local reverse_map = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
    [">"] = "<",
    -- ["<!--"] = "-->",
}

--- see `require("qwox.string")`
---@param str string
---@return string
function string.fancy_reverse(str)
    local buf = ""
    for c in str:gmatch "." do
        buf = (reverse_map[c] or c) .. buf
    end
    return buf
end

--- zero-indexed `string.sub`
--- see `require("qwox.string")`
---@param str string
---@param low integer 0-indexed; inclusive
---@param high? integer 0-indexed; exclusive
---@return string
function string.sub0(str, low, high)
    return str:sub(low + 1, high)
end

--- Returns the byte index (zero-indexed) for the first character of the first match of `pat`.
--- For pattern see [§5.4.1](http://www.lua.org/manual/5.1/manual.html#5.4.1)
--- see `require("qwox.string")`
---@param str string
---@param pat string
---@return integer | nil
function string.find0(str, pat)
    local pos = str:find(pat)
    if pos == nil then return nil end
    return pos - 1
end

--- Returns the byte index (zero-indexed) for the first character of the *last* match of `pat`.
--- For pattern see [§5.4.1](http://www.lua.org/manual/5.1/manual.html#5.4.1)
--- see `require("qwox.string")`
---@param str string
---@param pat string
---@return integer | nil
function string.rfind0(str, pat)
    local rev_pos = str:reverse():find(pat)
    if rev_pos == nil then return nil end
    return str:len() - rev_pos
end
