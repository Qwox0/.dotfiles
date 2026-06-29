local _ = {}

---@param ... string|string[]
function _.load_extension(...)
    local args = ...
    if type(args) == "string" then
        args = { args }
    end
    for _, ext in ipairs(args) do
        if pcall(require, "telescope._extensions." .. ext) then
            require("telescope").load_extension(ext)
        else
            vim.notify("Warn: telescope extension \"" .. ext .. "\" is missing!", "warn")
        end
    end
end

---# Usage
---```lua
---telescope.grep_string {
---   on_complete = { qwox.telescope.telescope_close_on_zero_results },
---}
---```
---@param picker Picker
function _.telescope_close_on_zero_results(picker)
    local results = picker.finder.results ---@diagnostic disable-line: undefined-field
    if #results == 0 then
        vim.notify("No results found!", "error")
        require "telescope.actions".close(picker.prompt_bufnr)
    end
end

---# Usage
---```lua
---telescope.grep_string {
---   on_complete = { qwox.telescope.telescope_jump_single_result },
---}
---```
---@param picker Picker
function _.telescope_jump_single_result(picker)
    local results = picker.finder.results ---@diagnostic disable-line: undefined-field
    if #results == 1 then
        require "telescope.actions".select_default(picker.prompt_bufnr)
    end
end

---# Usage
---```lua
---telescope.grep_string {
---   on_complete = qwox.telescope.default_on_complete,
---}
---```
_.default_on_complete = { _.telescope_close_on_zero_results, _.telescope_jump_single_result }

return _
