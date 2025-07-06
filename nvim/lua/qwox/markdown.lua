local export = {}

---@param heading_depth integer
---@param color string
local function change_heading_color(heading_depth, color)
    vim.colors.link("@markup.heading." .. heading_depth .. ".markdown", color)
    vim.colors.link("@markup.heading." .. heading_depth .. ".delimiter.markdown", "GruvboxGray")
end

function export.set_heading_colors()
    change_heading_color(1, "GruvboxRedBold")
    change_heading_color(2, "GruvboxYellowBold")
    change_heading_color(3, "GruvboxGreenBold")
    change_heading_color(4, "GruvboxBlueBold")
    change_heading_color(5, "GruvboxPurpleBold")
end

return export
