#! /bin/bash 
picom &
nitrogen --restore &
urxvtd -q -o -f &
xrandr --output DisplayPort-0 --mode 1920x1080 --rate 144 --primary --left-of DisplayPort-2 --output DisplayPort-2 --mode 1920x1080 --rate 144 &
xinput --set-prop * 'libinput Accel Speed' -1 &
xinput --set-prop 7 'libinput Accel Speed' -1
xinput --set-prop 8 'libinput Accel Speed' -1
xinput --set-prop 9 'libinput Accel Speed' -1
xinput --set-prop 10 'libinput Accel Speed' -1
xinput --set-prop 11 'libinput Accel Speed' -1
xinput --set-prop 12 'libinput Accel Speed' -1
xinput --set-prop 13 'libinput Accel Speed' -1
xinput --set-prop 14 'libinput Accel Speed' -1
