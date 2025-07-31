#!/bin/bash

# Get current workspace
ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')

# Get list of windows in the current workspace
swaymsg -t get_tree |
  jq -r '.. | try select(.type == "con" and .window_properties != null and .nodes == [] and .visible == true) | select(.workspace.name=="'"$ws"'") | "\(.id): \(.name)"' |
  wofi --dmenu --prompt "Switch to window:" --insensitive |
  cut -d':' -f1 |
  xargs -r swaymsg [con_id] focus
