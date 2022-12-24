#!/usr/bin/bash
# pkill -f $0
WALLPAPER_DIR=$HOME/Cloud/Pictures/wallpapers
while :
do
    feh --bg-fill --recursive --randomize $WALLPAPER_DIR $WALLPAPER_DIR
    sleep 30
done
