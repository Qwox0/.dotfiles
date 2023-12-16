local awful = require("awful")

local layout_list = require("vars").layout_list
--awful.layout.layouts = layouts

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts(layout_list)
end)
