local awful = require("awful")
local gears = require("gears")
local battery = awful.widget.watch("sh -c 'sb-battery'", 10)
battery:buttons(gears.table.join(
	awful.button({}, 4, function()
		awful.spawn.with_shell("xbacklight -inc 5")
	end),
	awful.button({}, 5, function()
		awful.spawn.with_shell("xbacklight -dec 5")
	end)
))

return battery
