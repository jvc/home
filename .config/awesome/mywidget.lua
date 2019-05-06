-- mostly come from http://sysphere.org/~anrxc/local/scr/dotfiles/awesomerc.lua.html
require("vicious")

confdir = awful.util.getdir("config")

-- {{{ Widget icons
beautiful.widget_cpu    = confdir .. "/icons-zenburn-anrxc/cpu.png"
beautiful.widget_bat    = confdir .. "/icons-zenburn-anrxc/bat.png"
beautiful.widget_mem    = confdir .. "/icons-zenburn-anrxc/mem.png"
beautiful.widget_fs     = confdir .. "/icons-zenburn-anrxc/disk.png"
beautiful.widget_net    = confdir .. "/icons-zenburn-anrxc/down.png"
beautiful.widget_netup  = confdir .. "/icons-zenburn-anrxc/up.png"
beautiful.widget_mail   = confdir .. "/icons-zenburn-anrxc/mail.png"
beautiful.widget_vol    = confdir .. "/icons-zenburn-anrxc/vol.png"
beautiful.widget_org    = confdir .. "/icons-zenburn-anrxc/cal.png"
beautiful.widget_date   = confdir .. "/icons-zenburn-anrxc/time.png"
beautiful.widget_crypto = confdir .. "/icons-zenburn-anrxc/crypto.png"
-- }}}

-- {{{ Widgets
beautiful.fg_widget        = "#AECF96"
beautiful.fg_center_widget = "#88A175"
beautiful.fg_end_widget    = "#FF5656"
beautiful.fg_off_widget    = "#494B4F"
beautiful.fg_netup_widget  = "#7F9F7F"
beautiful.fg_netdn_widget  = "#CC9393"
beautiful.bg_widget        = "#3F3F3F"
beautiful.border_widget    = "#3F3F3F"
-- }}}



-- {{{ Reusable separators
spacer         = widget({ type = "textbox", name = "spacer" })
spacer.text    = " "

separator      = widget({ type = "textbox", name = "separator" })
separator.text = "|"
-- }}}

-- {{{ CPU usage graph and temperature
-- Widget icon
cpuicon        = widget({ type = "imagebox", name = "cpuicon" })
cpuicon.image  = image(beautiful.widget_cpu)

-- Initialize widgets
thermalwidget  = widget({ type = "textbox", name = "thermalwidget" })
cpuwidget      = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft })

-- CPU graph properties
cpuwidget:set_width(50)
cpuwidget:set_scale(false)
cpuwidget:set_max_value(100)
cpuwidget:set_background_color(beautiful.fg_off_widget)
cpuwidget:set_border_color(beautiful.border_widget)
cpuwidget:set_color(beautiful.fg_end_widget)
cpuwidget:set_gradient_colors({
    beautiful.fg_end_widget,
    beautiful.fg_center_widget,
    beautiful.fg_widget })
-- Register widgets
awful.widget.layout.margins[cpuwidget.widget] = { top = 2, bottom = 2 }
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 2)
--vicious.register(thermalwidget, vicious.widgets.thermal, "$1°C", 60, "TZS0")
-- }}}

-- {{{ Memory usage bar
-- Widget icon
memicon       = widget({ type = "imagebox", name = "memicon" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
memwidget     = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft })
memwidget:set_width(30)
memwidget:set_scale(false)
memwidget:set_max_value(100)
memwidget:set_background_color(beautiful.fg_off_widget)
memwidget:set_border_color(beautiful.border_widget)
memwidget:set_color(beautiful.fg_end_widget)
memwidget:set_gradient_colors({
    beautiful.fg_end_widget,
    beautiful.fg_center_widget,
    beautiful.fg_widget })
awful.widget.layout.margins[memwidget.widget] = { top = 2, bottom = 2 }
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 10)

--memtwidget     = widget({ type = "textbox", name = "batwidget" })
--vicious.register(memtwidget, vicious.widgets.mem, "$1-$2-$3-$4", 1)
-- }}}



-- {{{ Battery percentage and state indicator
-- Widget icon
baticon       = widget({ type = "imagebox", name = "baticon" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget     = widget({ type = "textbox", name = "batwidget" })
-- Register widget
--vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 60, "BAT0")
vicious.register(batwidget, vicious.widgets.bat, "$1", 60, "BAT0")

-- Initialize widgets
batbarwidget  = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft })
-- VOL progressbar properties
batbarwidget:set_width(8)
--batbarwidget:set_height(14)
batbarwidget:set_vertical(true)
batbarwidget:set_background_color(beautiful.fg_off_widget)
batbarwidget:set_border_color(nil)
batbarwidget:set_color(beautiful.fg_widget)
batbarwidget:set_gradient_colors({
    beautiful.fg_widget,
    beautiful.fg_center_widget,
    beautiful.fg_end_widget })
awful.widget.layout.margins[batbarwidget.widget] = { top = 2, bottom = 2 }
-- Register widgets
vicious.register(batbarwidget, vicious.widgets.bat, "$2", 60, "BAT0")
-- }}}


-- {{{ Volume level, progressbar and changer
-- Widget icon
volicon       = widget({ type = "imagebox", name = "volicon" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbarwidget  = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft })
-- VOL progressbar properties
volbarwidget:set_width(8)
--volbarwidget:set_height(14)
volbarwidget:set_vertical(true)
volbarwidget:set_background_color(beautiful.fg_off_widget)
volbarwidget:set_border_color(nil)
volbarwidget:set_color(beautiful.fg_widget)
volbarwidget:set_gradient_colors({
    beautiful.fg_widget,
    beautiful.fg_center_widget,
    beautiful.fg_end_widget })
awful.widget.layout.margins[volbarwidget.widget] = { top = 2, bottom = 2 }
-- Register widgets
vicious.register(volbarwidget, vicious.widgets.volume, "$1", 2, "PCM")
-- Register buttons
volbarwidget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("gnome-volume-control", false) end),
    awful.button({ }, 2, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset PCM 2dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset PCM 2dB-", false) end)
))
--volwidget:buttons( volbarwidget.widget:buttons() )
-- }}}
