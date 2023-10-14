#!/usr/bin/bash

icon = "/home/root99/wall.png"
temp_bg = "/tmp/screen.png"

(( $# )) && { icon=$1; }
scrot "$temp_bg"
convert "$temp_bg" "$icon" -gravity center -composite -matte "$temp_bg"
i3lock -u -i "$temp_bg"
