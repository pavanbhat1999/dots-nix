local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local clock = awful.widget.watch("bash -c 'clock'", 1)
clock:buttons(gears.table.join(
    awful.button({}, 1, function()
        naughty.notify({
            text = "clock",
            timeout = 10,
            screen = mouse.screen
        })
    end)
))

return clock

