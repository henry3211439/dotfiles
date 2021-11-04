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
local naughty = require("naughty")
local menubar = require("menubar")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors 
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal   = "alacritty"
editor     = os.getenv("EDITOR") or "vscodium"
editor_cmd = terminal .. " -e " .. editor
browser    = "firefox"
filemgr    = "nemo"
--screenlocker = "gdbus monitor -y -d org.freedesktop.login1 | grep LockedHint"


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
altkey   = "Mod1"
superkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
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
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ 
    items = { 
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal }
    }
})

mylauncher = awful.widget.launcher({ 
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({},           1, function(t) t:view_only() end),
    awful.button({ superkey }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({},           3, awful.tag.viewtoggle),
    awful.button({ superkey }, 3, function(t) 
        if client.focus then client.focus:toggle_tag(t) end
    end),

    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
            )
        end
    end),
    awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({}, 4, function() awful.client.focus.byidx( 1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen

        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc( 1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc( 1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, visible = false })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        -- Left widgets
        { 
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },

        -- Middle widget
        s.mytasklist,

        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function () mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- System Action
    awful.key({ superkey, },           "h",         hotkeys_popup.show_help,
        { description = "Show keyboard shortcuts", group = "System" }),
    awful.key({ "Control", altkey },   "BackSpace", awesome.restart,
        { description = "Reload awesome",          group = "System" }),
    awful.key({ superkey, "Shift"   }, "q",         awesome.quit,
        { description = "Quit awesome",            group = "System" }),
    awful.key({ superkey, },           "l",         function() awful.spawn(screenlocker) end,
        { description = "Lock screen",             group = "System" }),

    -- Switch workspace
    awful.key({ superkey, },         "Tab", awful.tag.viewnext,
        { description = "Switch next workspace",     group = "Workspace" }),
    awful.key({ superkey, "Shift" }, "Tab", awful.tag.viewprev,
        { description = "Switch previous workspace", group = "Workspace" }),
    awful.key({ superkey, }, "Escape", awful.tag.history.restore,
        { description = "Switch last workspace",     group = "Workspace" }),

    -- Change window focus
    awful.key({ altkey, },         "Tab", function() awful.client.focus.byidx( 1) end,
        { description = "Focus next by index",     group = "Window" }),
    awful.key({ altkey, "Shift" }, "Tab", function() awful.client.focus.byidx(-1) end,
        { description = "Focus previous by index", group = "Window" }),
    -- awful.key({ superkey,           }, "Tab", function ()
    --         awful.client.focus.history.previous()

    --         if client.focus then client.focus:raise() end
    --     end,
    --     { description = "go back", group = "client" }),
    -- awful.key({ superkey, }, "w", function() mymainmenu:show() end,
    --     { description = "show main menu",          group = "Awesome" }),

    -- Change screen focus
    awful.key({ superkey, "Control" }, "j",   function() awful.screen.focus_relative( 1) end,
        { description = "Focus the next screen",     group = "Screen" }),
    awful.key({ superkey, "Control" }, "k",   function() awful.screen.focus_relative(-1) end,
        { description = "Focus the previous screen", group = "Screen" }),

    -- 
    -- awful.key({ superkey, }, "u", awful.client.urgent.jumpto,
    --     { description = "jump to urgent client", group = "Window" }),

    -- App launcher
    awful.key({ superkey },          "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "Run prompt",          group = "Application" }),
    awful.key({ "Control", altkey }, "t", function() awful.spawn(terminal) end,
        { description = "Open a Terminal",     group = "Application" }),
    awful.key({ superkey, }, "b",         function() awful.spawn(browser)  end,
        { description = "Open a Browser",      group = "Application" }),
    awful.key({ superkey, }, "e",         function() awful.spawn(filemgr)  end,
        { description = "Open a File Manager", group = "Application" }),

    -- Layout manipulation
    awful.key({ superkey, "Shift" }, "j", function() awful.client.swap.byidx( 1) end,
        { description = "swap with next window by index",     group = "Window" }),
    awful.key({ superkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous window by index", group = "Window" }),
    
    awful.key({ superkey, }, "l", function() awful.tag.incmwfact( 0.05) end,
        { description = "increase master width factor", group = "Layout" }),
    awful.key({ superkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "Layout" }),

    awful.key({ superkey, "Shift" }, "h", function() awful.tag.incnmaster( 1, nil, true) end,
        { description = "increase the number of master clients", group = "Layout" }),
    awful.key({ superkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "Layout" }),

    awful.key({ superkey, "Control" }, "h",     function() awful.tag.incncol( 1, nil, true) end,
        { description = "increase the number of columns", group = "Layout" }),
    awful.key({ superkey, "Control" }, "l",     function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "Layout" }),

    awful.key({ superkey,         }, "space", function() awful.layout.inc( 1) end,
        { description = "select next",     group = "Layout" }),
    awful.key({ superkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "Layout" }),

    -- Media control
    awful.key({ "XF86AudioRaiseVolume", }, "", function() 
            awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%") end, 
        { description = "Volume up",              group = "Media" }),
    awful.key({ "XF86AudioLowerVolume", }, "", function() 
            awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%") end, 
        { description = "Volume down",            group = "Media" }),
    awful.key({ "XF86AudioMute", },        "", function() 
            awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle") end, 
        { description = "Toggle mute volume",     group = "Media" }),
    awful.key({ "XF86AudioMicMute", },     "", function() 
            awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle") end, 
        { description = "Toggle mute microphone", group = "Media" }),

    -- Alternate media control
    awful.key({ "Control", },         "KP_Add",      function() 
            awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%") end, 
        { description = "Volume up",              group = "Media" }),
    awful.key({ "Control", },         "KP_Subtract", function() 
            awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%") end, 
        { description = "Volume down",            group = "Media" }),
    awful.key({ "Control", },         "KP_Divide",   function() 
            awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle") end, 
        { description = "Toggle mute volume",     group = "Media" }),
    awful.key({ "Control", "Shift" }, "KP_Divide",   function() 
            awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle") end, 
        { description = "Toggle mute microphone", group = "Media" })  

    -- Menubar
    -- awful.key({ superkey }, "p", function() menubar.show() end,
    --     { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
    awful.key({ superkey, }, "f", function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),

    awful.key({ superkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              { description = "close", group = "client" }),
    awful.key({ superkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              { description = "toggle floating", group = "client" }),
    awful.key({ superkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              { description = "move to master", group = "client" }),
    awful.key({ superkey,           }, "o",      function (c) c:move_to_screen()               end,
              { description = "move to screen", group = "Window" }),
    awful.key({ superkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              { description = "toggle keep on top", group = "Window" }),

    awful.key({ superkey, }, "Down", function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "Window" }),
    awful.key({ superkey, }, "Up",   function(c)
            local w = awful.client.restore()
                
            -- Focus restored client
            if w then
                w:emit_signal("request::activate", "key.unminimize", { raise = true })
            else
                c.maximized = not c.maximized
            end
            
            -- c:raise()
        end,
        { description = "Toggle maximize window", group = "Window" })

    -- awful.key({ superkey, "Control" }, "m", function(c)
    --         c.maximized_vertical = not c.maximized_vertical
    --         c:raise()
    --     end,
    --     { description = "Toggle maximize vertically", group = "Window" }),
    -- awful.key({ superkey, "Shift"   }, "m", function(c)
    --         c.maximized_horizontal = not c.maximized_horizontal
    --         c:raise()
    --     end,
    --     { description = "Toggle maximize horizontally", group = "Window" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ superkey }, "#" .. i + 9, function()
                local screen = awful.screen.focused()
                local tag    = screen.tags[i]

                if tag then tag:view_only() end
            end,
            { description = "view tag #" .. i, group = "Workspace" }),

        -- Toggle tag display.
        awful.key({ superkey, "Control" }, "#" .. i + 9, function()
                local screen = awful.screen.focused()
                local tag    = screen.tags[i]

                if tag then awful.tag.viewtoggle(tag) end
            end,
            { description = "toggle tag #" .. i, group = "Workspace" }),

        -- Move client to tag.
        awful.key({ superkey, "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]

                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "Workspace" }),

        -- Toggle tag on focused client.
        awful.key({ superkey, "Control", "Shift" }, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]

                    if tag then client.focus:toggle_tag(tag) end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "Workspace" })
    )
end

clientbuttons = gears.table.join(
    awful.button({},           1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ superkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ superkey }, 3, function(c)
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
            placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.center
        }
    },

    -- Floating clients.
    { 
        rule_any = {
            instance = {
                "DTA",              -- Firefox addon DownThemAll.
                "copyq",            -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",       -- kalarm.
                "Sxiv",
                "Tor Browser",      -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",     -- xev.
            },
            role = {
                "AlarmWindow",      -- Thunderbird's calendar.
                "ConfigManager",    -- Thunderbird's about:config.
                "pop-up",           -- e.g. Google Chrome's (detached) Developer Tools.
            }
      },
      properties = {
            floating = true
        }
    },

    -- Add titlebars to normal clients and dialogs
    { 
        rule_any = {
            type = {
                "normal",
                "dialog"
            }
        },
        properties = {
            -- titlebars_enabled = true
        }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    -- Make borderless on Polybar
    {
        rule = {
            class = "Polybar",
        },
        properties = {
            border_width = 0,
            useless_gap = 0,
            focusable = false,
        },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
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

    awful.titlebar(c) : setup {
        -- Left
        {
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },

        -- Middle
        {
            -- Title
            {
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },

        -- Right
        {
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),

            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", { raise = false })
-- end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Startup
awful.spawn.with_shell("~/.config/polybar/launch.sh")
