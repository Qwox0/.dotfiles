local core = {
    awesome      = awesome,
    button       = button,
    client       = client,
    dbus         = dbus,
    drawable     = drawable,
    drawin       = drawin,
    key          = key,
    keygrabber   = keygrabber,
    mouse        = mouse,
    mousegrabber = mousegrabber,
    root         = root,
    screen       = screen,
    tag          = tag,

    ---Everything related to window managment
    awful        = require("awful"),
    ---Awesome theme module
    beautiful    = require("beautiful"),
    ---Utilities such as color parsing and objects
    gears        = require("gears"),
    ---XDG (application) menu implementation
    menubar      = require("menubar"),
    ---Notifications
    naughty      = require("naughty"),
    ---Define declarative rules on various events
    ruled        = require("ruled"),
    ---Awesome own generic widget framework
    wibox        = require("wibox"),
}

return core
