local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
    print("telescope missing!")
    return
end

local themes = require("telescope.themes")

telescope.setup({
    defaults = {
        --file_ignore_patterns = { "git" }
        --file_ignore_patterns = { "^.git$" }
    },
    extensions = {
        ["ui-select"] = {
            themes.get_dropdown({

            })
        },
    },
})

telescope.load_extension("ui-select")
