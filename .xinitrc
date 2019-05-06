#!/bin/sh

# ## test for an existing bus daemon, just to be safe
# if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
#     ## if not found, launch a new one
#     eval `dbus-launch --exit-with-session --sh-syntax`
# fi

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session ~/.xsession
