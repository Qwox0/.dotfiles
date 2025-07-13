--- see ':help word'
local non_word_pattern = "[^%a%d_]" -- currently missing some allowed characters
--- see ':help WORD'
local non_WORD_pattern = "%s"

---get start and end of word under position `pos`
---see `require("qwox.string")`
---@param string string
---@param pos integer
---@param WORD boolean? see ':help word' and ':help WORD'
---@return integer word_start 0-indexed; inclusive
---@return integer word_end 0-indexed; exclusive
function string.get_word_pos(string, pos, WORD)
    local pat = WORD and non_WORD_pattern or non_word_pattern
    local word_start = (string:sub0(0, pos):rfind0(pat) or -1) + 1
    local word_end = string:sub0(pos):find0(pat)
    word_end = word_end ~= nil and word_end + pos or string:len()
    return word_start, word_end
end

---Split `string` multiple times.
---[start, end[; indices: `0`, `...`, `string.len()`;
---@param string string
---@param ... integer
---@return string ...
function string.multi_split(string, ...)
    ---@type integer[]
    local idxs = vim.tbl_filter(function(x) return x <= string:len() end, { string:len(), ... })
    table.sort(idxs)
    ---@type string[]
    local out = {}
    for k, idx in ipairs(idxs) do
        local prev = idxs[k - 1] or 0
        table.insert(out, string:sub0(prev, idx))
    end
    return table.unpack(out)
end

local reverse_map = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
    ["<"] = ">",
    [">"] = "<",
    -- ["<!--"] = "-->",
}

---see `require("qwox.string")`
---@param str string
---@return string
function string.fancy_reverse(str)
    local buf = ""
    for c in str:gmatch "." do
        buf = (reverse_map[c] or c) .. buf
    end
    return buf
end

---zero-indexed `string.sub`
---see `require("qwox.string")`
---negative indices work like in python.
---@param str string
---@param low integer 0-indexed; inclusive
---@param high? integer 0-indexed; exclusive
---@return string
function string.sub0(str, low, high)
    if low >= 0 then low = low + 1 end
    if high and high < 0 then high = high - 1 end
    return str:sub(low, high)
end

---Returns the byte index (zero-indexed) for the first character of the first match of `pat`.
---For pattern see [§5.4.1](http://www.lua.org/manual/5.1/manual.html#5.4.1)
---see `require("qwox.string")`
---@param str string
---@param pat string
---@return integer | nil
function string.find0(str, pat)
    local pos = str:find(pat)
    if pos == nil then return nil end
    return pos - 1
end

---Returns the byte index (zero-indexed) for the first character of the *last* match of `pat`.
---For pattern see [§5.4.1](http://www.lua.org/manual/5.1/manual.html#5.4.1)
---see `require("qwox.string")`
---@param str string
---@param pat string
---@return integer | nil
function string.rfind0(str, pat)
    local rev_pos = str:reverse():find(pat)
    if rev_pos == nil then return nil end
    return str:len() - rev_pos
end

---@param str string
---@param pat string
function string.ends_with(str, pat)
    return str:sub0(-pat:len()) == pat
end

---@param str string
---@param pat string
---@return string
function string.remove_end(str, pat)
    local new, end_ = str:multi_split(-pat:len())
    return end_ == pat and new or str
end

---Returns whether `str` starts with `pat`.
---@param str string
---@param pat string
---@return boolean
function string.starts_with(str, pat)
    return str:find(pat, 1, true) == 1
end

---@param str string
---@return integer
function string.wordcount(str)
    return vim.iter(vim.gsplit(str, "%s")):filter(function(s) return s:len() > 0 end):enumerate():last()
end

---@param str string
---@return integer
function string.humanwordcount(str)
    return vim.iter(str:gmatch("[^%c%s%z%p][^%c%s%z!#$%&’()%*%+,./:;<=>%?@%[\\%]^‘{|}~]+"))
        :filter(function(s) return s:len() > 0 end)
        :enumerate()
        :last()
end
