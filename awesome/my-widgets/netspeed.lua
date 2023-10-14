local awful = require("awful")
local gears = require("gears")
local my_net_speed = awful.widget.watch("sh -c 'netspeed'", 1)
my_net_speed:buttons(gears.table.join(
	awful.button({}, 3, function()
		awful.spawn.with_shell("kitty -e nmtui")
	end)
))

return my_net_speed
