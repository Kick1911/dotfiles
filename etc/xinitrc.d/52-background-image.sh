#!/usr/bin/bash
WALLPAPER_DIR=$HOME/Cloud/Pictures/wallpapers \
sh -c 'while :
do
    feh --bg-fill --recursive --randomize $WALLPAPER_DIR $WALLPAPER_DIR
    sleep 30
done' &
