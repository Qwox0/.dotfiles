table.unpack = unpack

table.count = vim.tbl_count

---@generic T
---@param tbl T[]
---@param x T
---@return boolean
function table.arr_contains(tbl, x)
    for _, element in ipairs(tbl) do
        if (element == x) then return true end
    end
    return false
end

---@param tbl table
---@param x any
---@return boolean
function table.contains(tbl, x)
    for _, element in pairs(tbl) do
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

---@param ... any[]
---@return any[]
function table.arr_concat(...)
    local out = {}
    for _, arr in ipairs({ ... }) do
        for _, elem in ipairs(arr) do
            table.insert(out, elem)
        end
    end
    return out
end

function table.find(tbl, predicate)
    for k, v in pairs(tbl) do
        if predicate(v) == true then
            return v
        end
    end
    return nil
end

---@generic T, U
---@param tbl T[]
---@param predicate fun(t: T): U
---@return U[]
function table.arr_map(tbl, predicate)
    local out = {}
    for _, v in ipairs(tbl) do
        table.insert(out, predicate(v))
    end
    return out
end

---@param tbl table
---@param predicate fun(t: any): any
---@return table
function table.map(tbl, predicate)
    local out = {}
    for k, v in pairs(tbl) do
        table.insert(out, k, predicate(v))
    end
    return out
end
