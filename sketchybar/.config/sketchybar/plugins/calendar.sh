#!/usr/bin/env sh

# Get the sketchybar command from environment variable
SKETCHYBAR_CMD="${SKETCHYBAR_CMD:-sketchybar}"

# Update calendar with current date and time
${SKETCHYBAR_CMD} --set calendar label="$(date '+%a %d %b %H:%M')"
