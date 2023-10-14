local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")

local volume = awful.widget.watch("bash -c 'sb-volume'",1)

volume:buttons(gears.table.join(
	awful.button({}, 1, function()
		naughty.notify({
			text = "This is Volume Control",
			timeout = 2,
			screen = mouse.screen,
		})
	end),
    -- middle click - toggle mute
    awful.button({}, 2, function()
        awful.spawn.with_shell("bash -c 'pamixer -t'")
    end),
	awful.button({}, 3, function()
		awful.spawn.with_shell("pavucontrol")
	end),
    awful.button({}, 4, function()
        awful.spawn.with_shell("bash -c 'pamixer -i 1'")
    end),
    awful.button({}, 5, function()
        awful.spawn.with_shell("bash -c 'pamixer -d 1'")
    end)
))

return volume
