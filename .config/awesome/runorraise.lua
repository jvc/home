---------------------------------------------------------------------------
-- @author Luca de Vries &lt;lucas@glacicle.com&gt;
-- @author Adrian C. &lt;anrxc@sysphere.org&gt;
-- @author Cedric Gestes &lt;ctaf42@gmail.com&gt;
-- @copyright 2009 Luca de Vries, Adrian C., Cedric Gestes
-- @release @AWESOME_VERSION@
---------------------------------------------------------------------------

-- Grab environment
local atag         = require("awful.tag")
local aclient      = require("awful.client")
local arules       = require("awful.rules")
local autil        = require("awful.util")
local setmetatable = setmetatable
local capi = {
    mouse = mouse,
    client = client,
}

local data      = {}
data.runorraise = setmetatable({}, { __mode = 'k' })

-- Functions
local runorraise   = {}
runorraise.__index = runorraise


-- functions
local properties    = {}
properties.default = {
    ontop       = true,
    above       = true,
    sticky      = true,
    floating    = true,
    skip_taskbar= true,
    width       = "90%",
    height      = "50%",
    placement   = "centered",
}


--- <h2>This module spawn application launched once then raised</h2><br/>
-- <p>awful.runorraise can apply a set of property on the target application,
--    A default set of property is used:<br/>
-- - sticky, floating, ontop, above, skip_taskbar <br/>
-- - centered, width = "90%", height = "50%" <br/>
-- <p>The default set could be override or discarded.<br/>
-- <code><br/>
-- -- redefine each property
-- gmrun     = teardrop("gmrun" , 1, {<br/>
--                          ontop       = true,<br/>
--                          above       = true,<br/>
--                          sticky      = false,<br/>
--                          floating    = true,<br/>
--                          skip_taskbar= true,<br/>
--                          width       = "90%",<br/>
--                          height      = "50%",<br/>
--                          placement   = "centered",<br/>
--                      })<br/>
-- -- append/change property of the default set
-- gnometerm = teardrop("gnome-terminal", 0, {<br/>
--                          append      = true,<br/>
--                          sticky      = false,<br/>
--                          tag         = tags[1][4],<br/>
--                      })<br/>
-- -- then define a keybinding to toggle the application using:<br/>
-- gmrun:toggle()<br/>
--</code>
module("awful.runorraise")


--- Show a runorraise
-- @param self The runorraise object
function runorraise:show()
    --if not self.active then
    self.client.hidden = false
    self.client:raise()
    capi.client.focus = self.client
    self.active = true
end

--- Hide a runorraise
-- @param self The runorraise object
function runorraise:hide()
    self.client.hidden = true
    self.active        = false
end

--- Spawn a new client
-- @param self The runorraise object
function runorraise:spawn()
    if self.client then return end

    spawn_cb = function(self, c)
        capi.client.disconnect_signal("manage", spawn_cb)
        if self.client then return end
        self.client      = c
        data.runorraise[c] = self
        if self.properties.append then
            arules.properties.set(c, properties.default)
        end
        arules.properties.set(c, self.properties)
        self:show()
    end
    -- Register a temporary signal
    capi.client.add_signal("manage", function(c) spawn_cb(self, c) end)
    -- Spawn program
    autil.spawn(self.prog, false)
end

--- Toggle the visibility of a runorraise
-- @param self The runorraise object
function runorraise:toggle()
    -- if the client is not running, spawn it
    if not self.client then
        self:spawn()
        return
    end

    -- handle the case when the client is hidden because he is shown on another tag
    if self.client:isvisible() == false and
       not self.properties.sticky       and
       not self.properties.tag          then
        aclient.movetotag(atag.selected(self.screen), self.client)
        self:show()
        return
    end
    if not self.active or self.client.hidden then
        self:show()
    else
        self:hide()
    end
end

--- Create a runorraise object
-- @param prog The program to spawn
-- @param screen The screen
-- @param props The set of property to apply on the runorraise client.
function new(prog, screen, props)
    if screen == nil           then screen = capi.mouse.screen  end

    local r      = {}
    --setup runorraise as a class
    setmetatable(r, runorraise)

    r.client     = nil
    r.active     = false
    r.prog       = prog
    r.screen     = screen
    r.properties = props or properties.default
    return r
end

--- Remove a runorraise associated to a client
-- @param c The client
local function unmanage(c)
    if data.runorraise[c] then
        data.runorraise[c].client = nil
        data.runorraise[c].active = false
    end
end

-- Add unmanage signal to remove associated runorraise when a client is killed
capi.client.add_signal("unmanage", unmanage)

setmetatable(_M, { __call = function (_, ...) return new(...) end })
