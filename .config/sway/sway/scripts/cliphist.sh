#!/bin/bash

# Fetch clipboard history using cliphist
CLIP_HISTORY=$(cliphist list)

# Check if the clipboard history is empty
if [ -z "$CLIP_HISTORY" ]; then
  # If empty, show a message
  wofi --show dmenu -e "Clipboard is empty"
else
  # Filter out command-like entries (e.g., starting with a percent or containing certain characters)
  FILTERED_HISTORY=$(echo "$CLIP_HISTORY" | grep -vE '^[0-9]+\s+[^\n]*[;|&$><]')

  # If no usable history remains after filtering
  if [ -z "$FILTERED_HISTORY" ]; then
    wofi --show dmenu -e "Clipboard contains no valid text"
  else
    # Display the filtered clipboard history in Wofi
    SELECTED_CLIP=$(echo "$FILTERED_HISTORY" | awk '{print $2}' | wofi --show dmenu -p "Clipboard History:")

    # If a selection was made, copy it back to clipboard
    if [ -n "$SELECTED_CLIP" ]; then
      echo -n "$SELECTED_CLIP" | xclip -selection clipboard
    fi
  fi
fi
