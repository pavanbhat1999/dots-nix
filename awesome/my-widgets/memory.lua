local awful = require("awful")
local battery = awful.widget.watch("bash -c 'disk' ", 300)

return battery


