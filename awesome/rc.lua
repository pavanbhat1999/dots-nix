-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
-- local naughty = require("naughty")
-- add sound for notification
-- function naughty.config.notify_callback(args)
-- 	awful.spawn.easy_async_with_shell("noti", function() end)
-- 	return args
-- end
-- local some_widget =
-- {
--     {
--             {
--                 {
--                     naughty.widget.icon,
--                     {
--                         naughty.widget.title,
--                         naughty.widget.message,
--                     valign = "center",
--                     halign = "center",
--                     forced_height = 100,
--                     forced_width = 500,
--                         spacing = 4,
--                         layout  = wibox.layout.align.vertical,
--                     },
--                     fill_space = true,
--                     spacing    = 4,
--                     valign = "top",
--                     halign = "center",
--                     layout     = wibox.layout.align.horizontal,
--                 },
--                 naughty.list.actions,
--                 spacing = 10,
--                 layout  = wibox.layout.align.horizontal,
--             },
--             margins = beautiful.notification_margin,
--             widget  = wibox.container.margin,
--         },
--         id     = "background_role",
--         widget = naughty.container.background,
--     }
-- -- naughty layout box
-- naughty.connect_signal("request::display", function(n)
--     naughty.layout.box {
--         notification = n,
--         widget_template = some_widget,
--     }
-- end)
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- local icon_size = dpi(150)
-- local default_template = {
-- 	{
-- 		----- Icon -----
-- 		--naughty.widget.icon,
-- 		{ ----- Icon -----
-- 			forced_width = icon_size,
-- 			forced_height = icon_size,
--
-- 			widget = naughty.widget.icon
-- 		},
-- 		{
-- 			{
-- 				{ ---- Title -----
-- 					naughty.widget.title,
--
-- 					valign = "center",
-- 					halign = "center",
--
-- 					widget = wibox.container.place
-- 				},
--
-- 				{ ----- Body/Message -----
-- 					naughty.widget.message,
--
-- 					valign = "top",
-- 					halign = "center",
--
-- 					widget = wibox.container.place
-- 				},
--
-- 				layout = wibox.layout.align.vertical,
-- 				expand = "outside",
--
-- 				},
--
-- 			margins = dpi(10),
-- 			widget = wibox.container.margin,
-- 		},
-- 		layout = wibox.layout.align.horizontal,
-- 	},
--
-- 	margins = dpi(10),
-- 	widget = wibox.container.margin
-- }
--
-- local template_without_icon = {
-- 	{
-- 		{
-- 			{ ---- Title -----
-- 				naughty.widget.title,
--
-- 				valign = "center",
-- 				halign = "center",
--                 forced_width = 500,
--                 forced_height = 100,
--
--                 widget = naughty.container.background
-- 				-- widget = wibox.container.place
-- 			},
--
-- 			{ ----- Body/Message -----
-- 				naughty.widget.message,
--
-- 				valign = "top",
-- 				halign = "center",
--
--                 widget = naughty.container.background
-- 			},
--
-- 			layout = wibox.layout.align.vertical,
-- 			expand = "outside",
--
-- 			},
--
-- 		margins = dpi(10),
-- 		widget = naughty.container.background
-- 	},
--
-- 	margins = dpi(10),
-- 	widget = wibox.container.margin
-- }
-- naughty.connect_signal("request::display", function(notification)
--
-- 	-- notification.timeout = 3
-- 	notification.resident = false
-- 	-- Only if there's an icon: Add the icon-widget
-- 	if notification.icon == nil then
-- 		naughty.layout.box {
-- 			notification = notification,
--
-- 			border_width = dpi(5),
-- 			screen = 1,
--
-- 			widget_template = template_without_icon
-- 		}
--
-- 	else
-- 		naughty.layout.box {
-- 			notification = notification,
--
-- 			border_width = dpi(5),
-- 			screen = 1,
--
-- 			widget_template = default_template
-- 		}
-- 	end
-- end)
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local eminent = require("eminent")
local dashCal = require("my-widgets.calendar")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

local dashboardBoxshape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
end
local makeDashboardBox = function(xval, yval, wval, hval)
    local box = wibox({
        --widget =
        x = xval,
        y = yval,
        width = wval,
        screen = s,
        height = hval,
        align = "center",
        valign = "center",
        visible = false,
        shape = dashboardBoxshape,
        bg = "#141B37",
        opacity = 0.75,
    })
    box.type = "dock"
    return box
end

-- Draws all the boxes needed for the dashboard
--			(Xpos, Ypos, Width, Height)
local dsbdCalendar = makeDashboardBox(150, 150, 455, 600)
dsbdCalendar.widget = dashCal
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
    -- exec dunt
    awful.spawn("notify-send 'error in config'")
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        -- naughty.notify({
        -- 	preset = naughty.config.presets.critical,
        -- 	title = "Oops, an error happened!",
        -- 	text = tostring(err),
        -- })
        awful.spawn("notify-send 'error in config'")
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/root99/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "kitty"
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual",      terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart",     awesome.restart },
    {
        "quit",
        function()
            awesome.quit()
        end,
    },
}

local mymainmenu = awful.menu({
    items = {
        { "awesome",       myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
    },
})

-- local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget with the current time 12 hour format
local mytextclock = wibox.widget.textclock([[%a %b %d %l:%M %p]], 1)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

-- local function set_wallpaper(s)
-- 	-- Wallpaper
-- 	if beautiful.wallpaper then
-- 		local wallpaper = beautiful.wallpaper
-- 		-- If wallpaper is a function, call it with the screen
-- 		if type(wallpaper) == "function" then
-- 			wallpaper = wallpaper(s)
-- 		end
-- 		gears.wallpaper.maximized(wallpaper, s, true)
-- 	end
-- end
local function set_wallpaper()
    -- awful.spawn.with_shell("nitrogen --restore")
    -- awful.spawn.with_shell("feh --randomize --bg-fill /home/root99/Downloads/tmpWall/")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper()
    -- gears.wallpaper.set("#1a1b26")
    -- gears.wallpaper.set(gears.color.create_pattern("#2B0E37"))

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    awful.tag(
        { "1. ", "2.☲ ", "3. ", "4. ", "5. ", "6. ", "7. ", "8. " },
        s,
        awful.layout.layouts[1]
    )
    awful.tag.add(" ", {
        s,
        layout = awful.layout.suit.floating,
    })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            fg_focus = "#C7A8A8",
        },
    })

    -- Create the wibox
    s.mywibox = awful.wibar({
        screen = s,
        fg = beautiful.fg_normal,
        height = 30,
        bg = beautiful.bg_normal,
        -- bg = beautiful.bg_normal .. '55', NOTE: If you want transperant bar
        position = "top",
        border_width = 5,
        border_color = beautiful.wibar_border,
        -- border_width = beautiful.border_width,
    })

    -- local seperator = wibox.widget.textbox("🔸")
    -- local my_net_speed = require("my-widgets.netspeed")
    -- local my_temp = require("my-widgets.temp")
    -- local my_brightness = require("my-widgets.brightness")
    -- local my_volume = require("my-widgets.volume")
    -- local my_memory = require("my-widgets.memory")
    -- local my_battery = require("my-widgets.battery")
    -- local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
    -- local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
    -- local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
    -- local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
    -- local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
    -- local my_clock = require("my-widgets.clock")
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            -- s.mypromptbox, TODO: Prompt is ugly
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- HACK: For polybar to work properly
            wibox.widget.textbox(
                "                                                                                                                                                                            ")
            -- mykeyboardlayout,
            -- TODO: Working On it------------------------------------------------------------------
            -- NOTE: Someone else widget
            -- seperator,
            -- my_net_speed,
            -- net_speed_widget(),
            -- seperator,
            -- my_temp,
            -- seperator,
            -- brightness_widget({
            -- 	type = "icon_and_text",
            -- 	program = "xbacklight",
            -- 	step = 5,
            -- }),
            -- my_brightness,
            -- seperator,
            -- volume_widget({
            -- 	widget_type = "text_and_icon",
            -- 	device = "default",
            -- }),
            -- my_volume,
            -- seperator,
            -- my_memory,
            -- fs_widget(), --default
            -- fs_widget({ mounts = { '/' } }),
            -- seperator,
            -- batteryarc_widget({
            -- 	show_current_level = true,
            -- 	arc_thickness = 1,
            -- 	show_notification_mode = "on_click",
            -- }),
            -- my_battery,
            -- battery_widget(),
            -- seperator,
            -- my_clock,
            -- mytextclock,
            -- s.mylayoutbox,
            -- wibox.widget.systray()
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function()
        mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local tags = awful.screen.focused().selected_tags
-- raise focused client
local function raise_client()
    if client.focus then
        client.focus:raise()
    end
end

local globalkeys = gears.table.join(
    awful.key({ modkey }, "F1", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
    -- awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    -- awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
    -- NOTE: Added Own Mappings for moving
    awful.key({ modkey }, "Down", function()
        awful.client.focus.bydirection("down")
        raise_client()
    end, { description = "focus down", group = "client" }),
    awful.key({ modkey }, "Up", function()
        awful.client.focus.bydirection("up")
        raise_client()
    end, { description = "focus up", group = "client" }),
    awful.key({ modkey }, "Left", function()
        awful.client.focus.bydirection("left")
        raise_client()
    end, { description = "focus left", group = "client" }),
    awful.key({ modkey }, "Right", function()
        awful.client.focus.bydirection("right")
        raise_client()
    end, { description = "focus right", group = "client" }),
    awful.key({ modkey, "Shift" }, "w", function()
        if dsbdCalendar.visible then
            dsbdCalendar.visible = false
        elseif dsbdCalendar.visible == false then
            dsbdCalendar.visible = true
        end
    end, { description = "open calender", group = "launcher" }),
    -- NOTE:End My own mappings keeping this bevause it might effect in future---------------------------
    awful.key({ modkey }, "bracketleft", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ modkey }, "bracketright", awful.tag.viewnext, { description = "view next", group = "tag" }),
    awful.key({ modkey }, "Tab", awful.tag.history.restore, { description = "go back", group = "tag" }),
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),
    awful.key({ modkey }, "w", function()
        mymainmenu:show()
    end, { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    -- awful.key({ modkey }, "Tab", function()
    -- 	awful.client.focus.history.previous()
    -- 	if client.focus then
    -- 		client.focus:raise()
    -- 	end
    -- end, { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control", "Shift" }, "e", awesome.quit, { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    -- awful.key({ modkey, "Shift" }, "space", function()
    -- 	awful.layout.inc(-1)TODO: changed default
    -- end, { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" })

-- awful.key({ modkey }, "x",
--           function ()
--               awful.prompt.run {
--                 prompt       = "Run Lua code: ",
--                 textbox      = awful.screen.focused().mypromptbox.widget,
--                 exe_callback = awful.util.eval,
--                 history_path = awful.util.get_cache_dir() .. "/history_eval"
--               }
--           end,
--           {description = "lua execute prompt", group = "awesome"}),
-- Menubar TODO: not yet used
-- awful.key({ modkey }, "-", function()
-- 	menubar.show()
-- end, { description = "show the menubar", group = "launcher" })
)

local clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    -- NOTE: Custom keybindings
    awful.key(
        { modkey, "Shift" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),
    awful.key({ modkey }, "o", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    -- HACK: minimize a window
    awful.key({ modkey, "Mod1" }, "n", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, { description = "minimize", group = "client" }),
    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" }),
    -- add shortcut to make current node sticky
    awful.key({ modkey }, "s", function(c)
        c.sticky = not c.sticky
        c.ontop = not c.ontop
        c:raise()
    end, { description = "Make window sticky", group = "client" }),
    -- for scratch pad implementation
    awful.key({ modkey }, "-", function(c)
        -- c.floating = true
        if client.focus then
            local tag = client.focus.screen.tags[9]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end, { description = "Move it to hidden tag", group = "client" }),

    awful.key({ modkey, "Shift" }, "-", function(c)
        local screen = awful.screen.focused()
        local tag = screen.tags[9]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end, { description = "Move back hidden tag", group = "client" }),
    awful.key({ modkey }, "x", function()
        -- toggle polybar
        awful.spawn.with_shell("sh $HOME/.config/polybar.old/launch_awesome.sh")
    end, { description = "Move back hidden tag", group = "client" }),
    awful.key({ modkey, "Shift" }, "x", function()
        awful.spawn.with_shell("killall -q polybar")
    end, { description = "Move back hidden tag", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },
    { rule = { class = "Polybar" },                 properties = { screen = 1, height = 30, tag = " " } },
    -- Set Brave to always map on the tag named "2" on screen 1.
    {
        rule = { class = "Brave-browser" },
        properties = {
            screen = 2,
            tag = "2. ",
            switchtotag = true,
            maximized = true
        }
    }, -- space sensitive 😅
    { rule = { class = "firefox" }, properties = { screen = 1, tag = "7. ", switchtotag = true } },
    {
        rule = { class = "Pcmanfm" },
        properties = {
            screen = 1,
            tag = "3. ",
            switchtotag = true,
            tiling = true
        }
    },
    {
        rule = { name = "ranger" },
        properties = { titlebars_enabled = false, floating = true, width = 1080, height = 720, x = 500, y = 200 },
    },
    {
        rule = { class = "mpv" },
        properties = {
            floating = true,
            width = 1080,
            height = 720,
            x = 500,
            y = 200,
            switchtotag = true,
            screen = 1,
            tag = "6. "
        }
    },
    { rule = { class = "Code" }, properties = { switchtotag = true, screen = 1, tag = "5. " } },
    { rule = { class = "Polybar" }, properties = { border_color = beautiful.polybar_border } },
    { rule = { class = "TelegramDesktop" }, properties = { floating = true, screen = 1, tag = " " } },
    { rule = { class = 'Virt-manager' }, properties = { switchtotag = true, screen = 1, tag = "6. " } },
    -- { rule = { class = "mpv" }, properties = { sticky = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
        {
            -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            -- Middle
            {
                -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c),
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        {
            -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
client.connect_signal("property::floating", function(c)
    if c.floating and not c.maximized and not c.fullscreen then
        c.border_width = 1
        c:geometry({
            width = 1080,
            height = 720,
            -- position centered on screen
            x = c.screen.geometry.x + (c.screen.geometry.width - 1080) / 2,
            y = c.screen.geometry.y + (c.screen.geometry.height - 720) / 2,
        })
    else
        c.border_width = beautiful.border_width
    end
end)
-- For Rounded borders on every client
-- client.connect_signal("manage", function (c)
--     c.shape = function(cr,w,h)
--         gears.shape.rounded_rect(cr,w,h,15)
--     end
-- end)
-- Gaps
beautiful.useless_gap = 5
beautiful.gap_single_client = true
--Auto Start
-- awful.spawn("bash -c nitrogen --restore")
-- Make a wallpaper slideshow
-- awful.widget.watch("bash -c 'change-wallpaper.sh'",15)
-- awful.spawn('bash -c sxhkd -c /home/root99/.config/sxhkd/sxhkdrc_dwm &')
