local A = {}

local awful = require("core").awful

local relative_to_word = function(dx)
    if type(dx) ~= "number" then return "ERROR" end
    if dx == 1 then
        return "next"
    elseif dx == -1 then
        return "previous"
    elseif dx >= 0 then
        return "+" .. tostring(dx)
    else
        return tostring(dx)
    end
end

function A.addkey(mod, key, action)
    if type(action.fn) ~= "function" or type(action.data) ~= "table" then return end -- ERROR: wrong action param
    return awful.key(mod, key, action.fn, action.data)
end

A.actions = {
    client = {},
    screen = {},
    tag = {},
}

A.actions.client.focus = {
    ---@param dx integer
    relative = function(dx)
        return {
            fn = function() awful.client.focus.byidx(dx) end,
            data = { description = "focus " .. relative_to_word(dx) .. " client", group = "client" },
        }
    end,
    ---@param direction "up"|"down"|"left"|"right"
    direction = function(direction)
        return {
            fn = function() awful.client.focus.bydirection(direction) end,
            data = { description = "focus " .. tostring(direction) .. " client", group = "client" },
        }
    end,
    ---@param direction "up"|"down"|"left"|"right"
    global_direction = function(direction)
        return {
            fn = function() awful.client.focus.global_bydirection(direction) end,
            data = { description = "focus " .. tostring(direction) .. " client across screens", group = "client" },
        }
    end,
    urgent = function()
        return {
            fn = awful.client.urgent.jumpto,
            data = { description = "focus client with notification", group = "client" },
        }
    end
}
A.actions.client.swap = {
    ---@param dx integer
    relative = function(dx)
        return {
            fn = function() awful.client.swap.byidx(dx) end,
            data = { description = "swap with " .. relative_to_word(dx) .. " client", group = "client" },
        }
    end,
    ---@param direction "up"|"down"|"left"|"right"
    direction = function(direction)
        return {
            fn = function() awful.client.swap.bydirection(direction) end,
            data = { description = "swap with " .. direction .. " client", group = "client" },
        }
    end,
    ---@param direction "up"|"down"|"left"|"right"
    global_direction = function(direction)
        return {
            fn = function() awful.client.swap.global_bydirection(direction) end,
            data = { description = "swap with " .. direction .. " client across screens", group = "client" },
        }
    end,
}
A.actions.client.move_to_tag = {
    ---@param idx integer
    absolute = function(idx)
        return {
            fn = function()
                if client.focus then
                    local tag = client.focus.screen.tags[idx]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            data = { description = "move focused client to tag", group = "tag" }
        }
    end,
    ---@param dx integer
    relative = function(dx)
        return {
            fn = function()
                if client.focus then
                    local idx = awful.screen.focused().selected_tag.index + dx
                    local tag = client.focus.screen.tags[idx]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            data = { description = "move focused client to " .. relative_to_word(dx) .. " tag", group = "tag" }
        }
    end,
}
--actions.client.cycle = awful.client.cycle

A.actions.screen.focus = {
    ---@param idx integer
    total = function(idx)
        return {
            fn = function() awful.screen.focus(idx) end,
            data = { description = "focus screen " .. tostring(idx), group = "screen" }
        }
    end,
    ---@param dx integer
    relative = function(dx)
        return {
            fn = function() awful.screen.focus_relative(dx) end,
            data = { description = "focus " .. relative_to_word(dx) .. " screen", group = "screen" }
        }
    end,
    ---@param direction "up"|"down"|"left"|"right"
    direction = function(direction)
        return {
            fn = function() awful.screen.focus_bydirection(direction) end,
            data = { description = "focus " .. direction .. " screen", group = "screen" }
        }
    end,
}

A.actions.tag.focus = {
    ---@param dx integer
    relative = function(dx)
        return {
            fn = function() awful.tag.viewidx(dx) end,
            data = { description = "focus " .. relative_to_word(dx) .. " tag", group = "tag" }
        }
    end,
}

return A
