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

local addkey = function(mod, key, action)
    if type(action.fn) ~= "function" or type(action.data) ~= "table" then return end -- ERROR: wrong action param
    return awful.key(mod, key, action.fn, action.data)
end

local actions = {
    client = {},
    screen = {},
    tag = {},
}
actions.client.focus = {
    relative = function(dx)
        return {
            fn = function() awful.client.focus.byidx(dx) end,
            data = { description = "focus " .. relative_to_word(dx) .. " client", group = "client" },
        }
    end,
    direction = function(direction)
        return {
            fn = function() awful.client.focus.bydirection(direction) end,
            data = { description = "focus " .. tostring(direction) .. " client", group = "client" },
        }
    end,
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
actions.client.swap = {
    relative = function(dx)
        return {
            fn = function() awful.client.swap.byidx(dx) end,
            data = { description = "swap with " .. relative_to_word(dx) .. " client", group = "client" },
        }
    end,
    direction = function(direction)
        return {
            fn = function() awful.client.swap.bydirection(direction) end,
            data = { description = "swap with " .. direction .. " client", group = "client" },
        }
    end,
    global_direction = function(direction)
        return {
            fn = function() awful.client.swap.global_bydirection(direction) end,
            data = { description = "swap with " .. direction .. " client across screens", group = "client" },
        }
    end,
}
--actions.client.cycle = awful.client.cycle

actions.screen.focus = {
    total = function(i)
        return {
            fn = function() awful.screen.focus(i) end,
            data = { description = "focus screen " .. tostring(i), group = "screen" }
        }
    end,
    relative = function(dx)
        return {
            fn = function() awful.screen.focus_relative(dx) end,
            data = { description = "focus " .. relative_to_word(dx) .. " screen", group = "screen" }
        }
    end,
    direction = function(direction)
        return {
            fn = function() awful.screen.focus_bydirection(direction) end,
            data = { description = "focus " .. direction .. " screen", group = "screen" }
        }
    end,
}

actions.tag.focus = {
    relative = function(dx)
        return {
            fn = function() awful.tag.viewidx(dx) end,
            data = { description = "focus " .. relative_to_word(dx) .. " tag", group = "tag" }
        }
    end,
}

return {
    actions = actions,
    addkey = addkey,
}
