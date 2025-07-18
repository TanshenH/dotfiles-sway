#!/bin/bash

# Get current volume (e.g. 0.25  [MUTED])
volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Parse volume value
volume=$(echo "$volume_info" | awk '{print $2 * 100}' | cut -d. -f1)
muted=$(echo "$volume_info" | grep -q MUTED && echo "🔇 Muted" || echo "🔊 $volume%")

# Send notification
notify-send "Volume : " "$muted"
