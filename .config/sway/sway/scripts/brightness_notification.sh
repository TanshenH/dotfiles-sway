#!/bin/bash

# Static notification ID for brightness updates
NOTIFICATION_ID="1085" # Different from volume ID to avoid conflicts

# Try to get brightness (supports both brightnessctl and light)
if command -v brightnessctl >/dev/null; then
  brightness=$(brightnessctl | grep -oP '\d+(?=%)')
  if [ $? -ne 0 ]; then
    notify-send -r "$NOTIFICATION_ID" -t 1000 -u critical "Brightness Error" "Failed to get brightness (brightnessctl)"
    exit 1
  fi
elif command -v light >/dev/null; then
  brightness=$(light -G | cut -d. -f1)
  if [ $? -ne 0 ]; then
    notify-send -r "$NOTIFICATION_ID" -t 1000 -u critical "Brightness Error" "Failed to get brightness (light)"
    exit 1
  fi
else
  notify-send -r "$NOTIFICATION_ID" -t 1000 -u critical "Brightness Error" "No brightness control tool found (install brightnessctl or light)"
  exit 1
fi

# Status emoji (you can customize these)
if [ "$brightness" -eq 0 ]; then
  status="🌑 Off"
elif [ "$brightness" -lt 30 ]; then
  status="🔅 $brightness%"
elif [ "$brightness" -lt 70 ]; then
  status="🔆 $brightness%"
else
  status="☀️ $brightness%"
fi

# Send/replace notification using swaync-client
notify-send -r "$NOTIFICATION_ID" -t 1000 "Brightness" "$status"
