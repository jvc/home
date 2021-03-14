#!/bin/sh

export PATH=$HOME/bin:$PATH

# Set background
xsetroot -solid "#1b1721" &

# Restart ssh-agent and set up environment
pkill ssh-agent 2>/dev/null
pkill -9 ssh-agent 2>/dev/null
eval $(ssh-agent)

# Load defaults
xrdb -merge $HOME/.Xdefaults &

# Disable bell
xset b off &

# Disable screensaver
xset s off &

# Enable Energy Star to turn display off after 10 minutes
xset dpms 0 0 600 &

# xset does not work with libinput
# xset m 4/1 4 &

# Set primary display to 60% brightness to start at
xrandr --output eDP-1 --brightness 0.6 &

# Notification daemon
dunst &

# No polkit agent required anymore
# /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Use $HOME/bin/startapplets so these can be restarted easily
#redshift-gtk -m randr:crtc=0 &
startapplets

# Key bindings
xmodmap ~/.xmodmap/CapsLock_to_Escape.xmodmap

gpaste-client start &

exec i3
