#!/bin/bash

# old:
#sleep 5
#/usr/bin/xrandr --output XWAYLAND0 --scale 1.75x1.75 --pos 3840x500

xrandr --output HDMI-A-0 --scale 1x1 --pos 1215x0 --primary \
    --output HDMI-A-1 --scale 1.125x1.125 --pos 0x0 --rotate right
