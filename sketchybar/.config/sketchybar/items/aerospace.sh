#!/usr/bin/env bash

echo "  → [aerospace.sh] Loading with command: ${SKETCHYBAR_CMD:-sketchybar}"
echo "  → [aerospace.sh] FONT: $FONT"
echo "  → [aerospace.sh] ITEM_DIR: $ITEM_DIR"
echo "  → [aerospace.sh] PLUGIN_DIR: $PLUGIN_DIR"
echo "  → [aerospace.sh] Found workspaces: $(aerospace list-workspaces --all)"

${SKETCHYBAR_CMD:-sketchybar} --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
    ${SKETCHYBAR_CMD:-sketchybar} --add item space."$sid" left \
        --subscribe space."$sid" aerospace_workspace_change \
        --set space."$sid" \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label.font.size=14.0 \
        label="$sid" \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospacer.sh $sid"
done

echo "  → [aerospace.sh] Items created successfully"

