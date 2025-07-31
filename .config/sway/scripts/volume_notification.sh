#!/bin/bash

# Static notification ID for volume updates
NOTIFICATION_ID="1084"
MAX_VOLUME=150 # Set maximum volume to 150%

# Get current volume
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)

# Check if wpctl failed
if [ $? -ne 0 ]; then
  notify-send -r "$NOTIFICATION_ID" -t 1000 -u critical "Volume Error" "Failed to get volume"
  exit 1
fi

# Parse current volume (0-1 scale)
current_volume=$(echo "$volume_info" | awk '{print $2}')

# Handle volume increase requests (called with +5% etc.)
if [[ "$1" == "increase" ]]; then
  new_volume=$(echo "$current_volume + 0.05" | bc -l)
  # Cap at MAX_VOLUME (150%)
  if (($(echo "$new_volume * 100 > $MAX_VOLUME" | bc -l))); then
    new_volume=$(echo "$MAX_VOLUME / 100" | bc -l)
    notify-send -r "$NOTIFICATION_ID" -t 1000 "Volume" "🔊 Max volume reached (150%)"
  fi
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$new_volume"
fi

# Handle volume decrease requests
if [[ "$1" == "decrease" ]]; then
  wpctl set-volume @DEFAULT_AUDIO_SINK@ "$(echo "$current_volume - 0.05" | bc -l)"
fi

# Handle mute toggle
if [[ "$1" == "toggle" ]]; then
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
fi

# Get updated status
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo "$volume_info" | awk '{print $2 * 100}' | cut -d. -f1)

if echo "$volume_info" | grep -q MUTED; then
  status="🔇 Muted"
else
  status="🔊 $volume%"
fi

# Send notification
notify-send -r "$NOTIFICATION_ID" -t 1000 "Volume" "$status"
