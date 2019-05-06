-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Widget and layout library
require("wibox")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("scratch")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/local/share/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
editor = "emacsclient -c"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- }}}
--
-- {{{ Functions
--
function getshorthostname()
   local file = io.popen("/bin/hostname -s")
   local output = file:read("*a")
   file:close()
   shortname = output:gsub("%s*$", "")
   return shortname
end

function layoutinfo()
   local curtag = awful.tag.selected()
   local nmas = awful.tag.getnmaster(curtag)
   local mwfact = awful.tag.getmwfact(curtag)
   local ncol = awful.tag.getncol(curtag)

   naughty.notify{
      title = '<span weight="bold" color="white">Layout Info</span>',
      text = ('<span weight="bold">Number of Masters</span> ' .. nmas .. '<br>' ..
              '<span weight="bold">Master Window Factor</span> ' .. mwfact .. '<br>' ..
              '<span weight="bold">Number of Columns</span> ' .. ncol
        ),
      hover_timeout = 0.0, timeout = 10.0,
   }
end
--
-- }}} Functions
--

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[3])
end
-- }}}
-- Per host overrides
hostname = getshorthostname()
if hostname == "lfod" or hostname == "localhost" then
   for snum = 1, screen.count() do
      if screen[snum].geometry.width >= 1800 then
         cur = tags[snum][1]
         awful.layout.set(awful.layout.suit.tile.left, cur)
         awful.tag.setncol(2, cur)
         awful.tag.setnmaster(1, cur)
         awful.tag.setmwfact(0.33, cur)

         -- 1 wide master (Browser) on lhs
         cur = tags[snum][2]
         awful.tag.setmwfact(0.75, cur)
         awful.layout.set(awful.layout.suit.tile, cur)

         -- 1 master on rhs (tmux) 2 col
         for tnum = 3, 4 do
            cur = tags[snum][tnum]
            awful.layout.set(awful.layout.suit.tile.left, cur)
            awful.tag.setncol(2, cur)
            awful.tag.setnmaster(1, cur)
            awful.tag.setmwfact(.33, cur)
         end

         -- float 5
         for tnum = 5, 5 do
            cur = tags[snum][tnum]
            awful.layout.set(awful.layout.suit.float, cur)
         end

         -- 6
         cur = tags[snum][6]
         awful.layout.set(awful.layout.suit.tile.left, cur)
         awful.tag.setncol(2, cur)
         awful.tag.setnmaster(1, cur)
         awful.tag.setmwfact(0.33, cur)

         -- 1 on lhs (deluge-gtk, music player, volume-control) 1 col
         for tnum = 7, 7 do
            cur = tags[snum][tnum]
            awful.layout.set(awful.layout.suit.tile, cur)
            awful.tag.setmwfact(0.66, cur)
            awful.tag.setnmaster(1, cur)
         end

         -- 1 master on rhs (tmux) 2 col
         for tnum = 8, 9 do
            cur = tags[snum][tnum]
            awful.layout.set(awful.layout.suit.tile.left, cur)
            awful.tag.setncol(2, cur)
            awful.tag.setnmaster(1, cur)
            awful.tag.setmwfact(.33, cur)
         end
      end
   end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- JCHOUINARD
-- require("mymenu")

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "l", awful.tag.history.restore),

    awful.key({ modkey,           }, "n",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "p",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "n", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "p", function () awful.client.swap.byidx( -1)    end),
    -- awful.key({ modkey, "Control" }, "p", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn(editor) end),
    -- awful.key({ modkey, "Control" }, "r", awesome.restart),

    awful.key({ modkey            }, "=",     function () awful.client.incwfact( 0.05)  end),
    awful.key({ modkey            }, "-",     function () awful.client.incwfact(-0.05)  end),
    awful.key({ modkey,           }, "i",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "d",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "i",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "d",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "i",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "d",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ modkey }, "s",  function() scratch.pad.toggle() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift" }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "o", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    -- awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ modkey, "Shift"          }, "m",
        function (c)
            c.maximized_vertical   = not c.maximized_vertical
           c.ontop = c.maximized_vertical
        end),
    awful.key({ modkey, "Shift" }, "s",  function(c) scratch.pad.set(c, 0.40, 0.50, false, nil, nil) end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- }}}

function set_slave(client)
   if not awful.client.floating.get(client) then
      awful.client.setslave(client)
   end
end

function urxvt_set_rules(client)
   if not awful.client.floating.get(client) then
      awful.client.setslave(client)
   end
end

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
   -- Terminals
   -- TODO: make these callbacks
    { rule = { class = "URxvt",
               instance = "tag_1" },
      properties = { tag = tags[screen.count()][1] } },
    { rule = { class = "URxvt",
               instance = "tag_2" },
      properties = { tag = tags[screen.count()][2] } },
    { rule = { class = "URxvt",
               instance = "tag_3" },
      properties = { tag = tags[screen.count()][3] } },
    { rule = { class = "URxvt",
               instance = "tag_4" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "URxvt",
               instance = "tag_5" },
      properties = { tag = tags[screen.count()][5] } },
    { rule = { class = "URxvt",
               instance = "tag_6" },
      properties = { tag = tags[screen.count()][6] } },
    { rule = { class = "URxvt",
               instance = "tag_7" },
      properties = { tag = tags[screen.count()][7] } },
    { rule = { class = "URxvt",
               instance = "tag_8" },
      properties = { tag = tags[screen.count()][8] } },
    { rule = { class = "URxvt",
               instance = "tag_9" },
      properties = { tag = tags[screen.count()][9] } },

    { rule = { class = "URxvt" },
      callback = set_slave },

    { rule = { instance = "emacs" },
      callback = set_slave },
    { rule = { instance = "NC" },
      callback = set_slave },

    { rule = { class = "Gnome-terminal" },
      callback = set_slave },
    { rule = { class = "Xfce4-terminal" },
      callback = set_slave },

    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
      properties = { floating = true } },

    -- Set Firefox to always map on tags number 2, last screen.
    { rule = { class = "Firefox" },
      properties = { tag = tags[screen.count()][2], floating = true } },

    -- Browser
     -- { rule = { instance = "Navigator" },
     --   properties = { floating = true } },

     -- { rule_any = {
     --      instance = { "Browser", "Dialog", "Download", "Extension" }
     --   },

     --   properties = { floating = true },
     --   callback = awful.placement.centered },

     { rule = { class = "Gnome-keyring-prompt" },
      properties = { sticky = true } },

   -- Other
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)


    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}
