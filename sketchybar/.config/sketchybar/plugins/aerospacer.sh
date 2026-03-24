#!/bin/bash

echo "  → [aerospacer.sh] Called with workspace: $1"
echo "  → [aerospacer.sh] Current focused workspace: $FOCUSED_WORKSPACE"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    echo "  → [aerospacer.sh] Setting $NAME background.drawing=on"
    ${SKETCHYBAR_CMD:-sketchybar} --set $NAME background.drawing=on
else
    echo "  → [aerospacer.sh] Setting $NAME background.drawing=off"
    ${SKETCHYBAR_CMD:-sketchybar} --set $NAME background.drawing=off
fi

