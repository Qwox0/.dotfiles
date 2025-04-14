local _ = {}

local f = io.popen("find " .. require("qwox.util").paths.nvim_config .. "/templates -mindepth 1")
if f == nil then return end

_.templates = {}

---@param path string
for path in f:lines() do
    table.insert(_.templates, path)

    ---@type string
    local ext = path:sub0((path:rfind0("%.") or -1) + 1)
    vim.autocmd.new("BufNewFile", { pattern = "*." .. ext, callback = function() _.insert_template(path) end })
end

---@param template_path string
function _.insert_template(template_path)
    vim.cmd("0r " .. template_path)
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
                _.insert_template(action_state.get_selected_entry()[1])
            end)
            return true
        end,
    }):find()
end

vim.command.set("Template", _.apply_template)

return _
