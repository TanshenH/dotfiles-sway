#!/bin/bash
WALLPAPER=$(pgrep -a swaybg | awk '{for(i=1;i<=NF;i++) if ($i=="-i") print $(i+1)}')

swaylock \
  --image "$WALLPAPER" \
  --config ~/.config/swaylock/config
