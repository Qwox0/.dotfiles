local function debug_msg(msg)
    require("naughty").notify {
        title = "Debug",
        text = msg
    }
end

return {
    debug_msg = debug_msg,
}
