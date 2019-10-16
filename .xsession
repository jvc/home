#!/bin/sh

pkill ssh-agent 2>/dev/null
pkill -9 ssh-agent 2>/dev/null
eval $(ssh-agent)

export PATH=$HOME/bin:$PATH

# HighRes stuff
#export GDK_SCALE=1.3
xrandr --dpi 128 &

#xsetroot -solid "#001616" &
#xsetroot -solid "#483958" &
xsetroot -solid "#1b1721" &
xrdb -merge $HOME/.Xdefaults &
xset b off &
xset s off &
xset dpms 0 0 600 &
xset m 4/1 4 &

dunst &
#wicd-gtk --tray &
nm-applet &
udiskie -s &
blueman-applet &

clipit &
xmodmap ~/.xmodmap/CapsLock_to_Escape.xmodmap

ssh-add &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

exec i3
