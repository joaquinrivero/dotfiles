#!/usr/bin/env sh

echo "  → [spaces.sh] Loading with command: ${SKETCHYBAR_CMD:-sketchybar}"
echo "  → [spaces.sh] FONT: $FONT"
echo "  → [spaces.sh] ITEM_DIR: $ITEM_DIR"
echo "  → [spaces.sh] PLUGIN_DIR: $PLUGIN_DIR"
echo "  → [spaces.sh] Found workspaces: $(aerospace list-workspaces --all)"
echo "  → [spaces.sh] Creating space items..."

${SKETCHYBAR_CMD:-sketchybar} --add event aerospace_workspace_change
RED=0xffed8796
# Only show workspaces 1-4 (matching your keybindings)
for sid in 1 2 3 4; do
    ${SKETCHYBAR_CMD:-sketchybar} --add item "space.$sid" left \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
        icon="$sid"\
                              icon.padding_left=22                          \
                              icon.padding_right=22                         \
                              label.padding_right=33                        \
                              icon.highlight_color=$RED                     \
                              background.color=0x44ffffff \
                              background.corner_radius=5 \
                              background.height=30 \
                              background.drawing=off                         \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.background.height=30                    \
                              label.background.drawing=on                   \
                              label.background.color=0xff494d64             \
                              label.background.corner_radius=9              \
                              label.drawing=off                             \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospacer.sh $sid"
done

${SKETCHYBAR_CMD:-sketchybar}   --add item       separator left                          \
             --set separator  icon=                                  \
                              icon.font="Hack Nerd Font:Regular:16.0" \
                              background.padding_left=15              \
                              background.padding_right=15             \
                              label.drawing=off                       \
                              associated_display=active               \
                              icon.color=$WHITE

echo "  → [spaces.sh] Items created successfully"
