#!/usr/bin/env bash

# ~/.xinitrc
# executed by startx
# used for GUI related settings (key bindings: xkbcomp; X resources: xrdb)
# used to start GUI

( # x server hasn't started yet -> sleep needed
    sleep 5
    # set keyboard layout
    [ -f $HOME/.keyboard/my_layout.xkb ] && xkbcomp $HOME/.keyboard/my_layout.xkb $DISPLAY &

    #xrdb -cpp /usr/bin/cpp-4.7 -merge ~/.Xresources
    xrdb -load $HOME/.Xresources

    # disable bell
    xset -b

    echo ".xinitrc3" >> $HOME/asdf
    # disable all power saving
    xset -dpms
    xset s off
) &

# start window manager
exec awesome
