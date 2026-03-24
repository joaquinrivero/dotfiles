#!/usr/bin/env sh

echo "  → [calendar.sh] Loading with command: ${SKETCHYBAR_CMD:-sketchybar}"
echo "  → [calendar.sh] FONT: $FONT"
echo "  → [calendar.sh] ITEM_DIR: $ITEM_DIR"
echo "  → [calendar.sh] PLUGIN_DIR: $PLUGIN_DIR"

${SKETCHYBAR_CMD:-sketchybar} --add item     calendar right               \
           --set calendar icon=cal                     \
                          icon.color=$WHITE            \
                          icon.font="$FONT:Black:12.0" \
                          icon.padding_left=5          \
                          icon.padding_right=5         \
                          icon.drawing=off             \
                          label.color=$WHITE           \
                          label.padding_left=5         \
                          label.padding_right=5        \
                          background.drawing=off       \
                          update_freq=30               \
                          script="$PLUGIN_DIR/calendar.sh"

echo "  → [calendar.sh] Items created successfully"
