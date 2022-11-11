-- on require("qwox.screen") returns Screen which manages multiple vim windows

local cmds = {
    ["up"]    = { move = "<C-w>k", new = "<C-w>s" },
    ["down"]  = { move = "<C-w>j", new = "<C-w>s" },
    ["left"]  = { move = "<C-w>h", new = "<C-w>v" },
    ["right"] = { move = "<C-w>l", new = "<C-w>v" },
}

local new = function(direction)
    if cmds[direction] then
        return cmds[direction].new
    else
        print("lua.qwox.screen.Screen.new: Invalid direction")
    end

end

local move = function(direction)
    if cmds[direction] then
        return cmds[direction].move
    else
        print("lua.qwox.screen.Screen.move: Invalid direction")
    end
end

return {
    new = new,
    move = move,
}
