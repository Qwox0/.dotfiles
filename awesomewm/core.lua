return {
    awesome = awesome,
    client = client,
    drawable = drawable,
    mousegrabber = mousegrabber,
    root = root,
    screen = screen,
    tag = tag,

    gears = require("gears"), -- Utilities such as color parsing and objects
    awful = require("awful"), -- Everything related to window managment
    wibox = require("wibox"), -- Awesome own generic widget framework
    naughty = require("naughty"), -- Notifications
    ruled = require("ruled"), -- Define declarative rules on various events
    menubar = require("menubar"), -- XDG (application) menu implementation
    beautiful = require("beautiful"), -- Awesome theme module
}
