#!/usr/bin/bash
files=(~/Downloads/Wall/*)
WALLPAPER=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
WALLPAPER2=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")
feh -B white --bg-fill $WALLPAPER --bg-fill $WALLPAPER2
