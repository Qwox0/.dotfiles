#!/bin/sh


# ~/.xsession
# doesn't work!
# run by login managers if no session/window manager is selected

gnome-screensaver &
gnome-settings-daemon &

export $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)

#xrdb -cpp /usr/bin/cpp-4.7 -merge ~/.Xresources
#xrandr --output HDMI2 --right-of HDMI1

#exec awesome
