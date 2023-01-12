-- If LuaRocks is installed, make sure that packages installed through it are found (e.g. lgi).
pcall(require, "luarocks.loader")

require("awful.autofocus")
require("awful.hotkeys_popup.keys") -- Enable hotkeys help widget for VIM and other apps when client with a matching name is opened:

require("error_handling")

require("vars").init()

require("tag")
require("screen")
require("bindings")
require("rules")
require("client")
require("notifications")

require("autostart").run()
