local qwox_util = require("qwox.util")
local buf_path = qwox_util.get_buf_path()

vim.opt_local.wrap = true
vim.opt_local.linebreak = true

if string.starts_with(buf_path, qwox_util.paths.obsidian) then
    vim.opt_local.conceallevel = 2
end

---@param heading_depth integer
---@param color string
local function change_heading_color(heading_depth, color)
    vim.colors.link("markdownH" .. heading_depth, color)
    --vim.colors.link("markdownH" .. heading_depth .. "Delimiter", "GruvboxGrayBold")
    vim.colors.link("markdownH" .. heading_depth .. "Delimiter", "GruvboxGray")
    vim.colors.del("@markup.heading." .. heading_depth .. ".markdown")
end

change_heading_color(1, "GruvboxRedBold")
change_heading_color(2, "GruvboxYellowBold")
change_heading_color(3, "GruvboxGreenBold")
change_heading_color(4, "GruvboxBlueBold")
change_heading_color(5, "GruvboxPurpleBold")
