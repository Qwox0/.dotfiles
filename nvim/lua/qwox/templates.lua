local _ = {}

local f = io.popen("find " .. require("qwox.util").paths.nvim_config .. "/templates -mindepth 1 -maxdepth 1 -type f")
if f == nil then return end

_.templates = {}

---@param path string
for path in f:lines() do
    table.insert(_.templates, path)

    local ext = string.match(path, "^.*/%.([^%.]*)$")
    if ext ~= nil then
        vim.autocmd.new("BufNewFile", {
            pattern = "*." .. ext,
            callback = function() _.insert_template(path, true) end,
        })
    end
end

---@param template_path string
---@param new_file boolean
function _.insert_template(template_path, new_file)
    if new_file then
        vim.cmd("0r " .. template_path)
    else
        vim.cmd("r " .. template_path)
    end
end

function _.apply_template(opts)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Apply template",
        finder = finders.new_table { results = _.templates },
        sorter = conf.generic_sorter(opts),
        previewer = conf.grep_previewer(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                _.insert_template(action_state.get_selected_entry()[1], false)
            end)
            return true
        end,
    }):find()
end

vim.command.set("Template", _.apply_template)

return _
