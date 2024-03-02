local O = {}

---@param ... string|string[]
function O.load_extension(...)
    local args = ...
    if type(args) == "string" then
        args = { args }
    end
    for _, ext in ipairs(args) do
        if pcall(require, "telescope._extensions." .. ext) then
            require("telescope").load_extension(ext)
        else
            vim.notify("Warn: telescope extension \"" .. ext .. "\" is missing!")
        end
    end
end

return O
