#!/bin/bash

killall waybar fcitx5 vicinae 

kanshi &
vicinae server &
waybar &
fcitx5 -d &
awww-daemon &
wl-paste --type image --watch cliphist store &
wl-paste --type text --watch cliphist store &

exec foot --server 
