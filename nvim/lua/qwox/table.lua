table.unpack = unpack

table.count = vim.tbl_count

---@generic T
---@param tbl `T`[]
---@param x T
---@return boolean
function table.contains(tbl, x)
    for _, element in ipairs(tbl) do
        if (element == x) then return true end
    end
    return false
end

---uses `f` to determine if an element of the table `tbl` should be kept.
---@generic K, V
---@param tbl table<K, V> table to filter
---@param f fun(key: K, value: V): boolean filter function
---@return table<K, V> filtered filtered table
function table.filter(tbl, f)
    local filtered = {}
    for key, val in pairs(tbl) do
        if f(key, val) then
            filtered[key] = val
        end
    end
    return filtered
end
