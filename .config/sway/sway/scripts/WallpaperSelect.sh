#!/bin/bash

# Define the image directory
IMAGE_DIR="$HOME/.images"

# Check if the directory exists
if [ ! -d "$IMAGE_DIR" ]; then
  wofi --show dmenu -e "Directory $IMAGE_DIR not found!"
  exit 1
fi

# List all image files in the directory (only .jpg, .png, .jpeg, .bmp)
IMAGE_LIST=$(find "$IMAGE_DIR" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.bmp \))

# If no images found, show a message
if [ -z "$IMAGE_LIST" ]; then
  wofi --show dmenu -e "No images found in $IMAGE_DIR!"
  exit 1
fi

# Extract just the filenames (without path)
IMAGE_NAMES=$(echo "$IMAGE_LIST" | while read image; do
  # Extract the filename without the path using basename
  basename "$image"
done)

# Let the user select an image using Wofi
SELECTED_IMAGE=$(echo "$IMAGE_NAMES" | wofi --show dmenu -p "Select Wallpaper:")

# If an image was selected, set it as wallpaper using swaybg and run wallust
if [ -n "$SELECTED_IMAGE" ]; then
  # Find the full path of the selected image
  FULL_PATH=$(echo "$IMAGE_LIST" | grep -m 1 "$SELECTED_IMAGE")

  # Set the selected image as wallpaper using swaybg
  swaybg -i "$FULL_PATH" -m fill

  # Run wallust with the selected image
  if command -v wallust &>/dev/null; then
    wallust "$FULL_PATH"
  elif command -v wal &>/dev/null; then
    wal -i "$FULL_PATH" -n # -n prevents setting wallpaper (since we're using swaybg)
  else
    wofi --show dmenu -e "Neither wallust nor pywal is installed!"
  fi
fi
