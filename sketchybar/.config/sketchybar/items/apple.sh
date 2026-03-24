#!/usr/bin/env sh

echo "  → [apple.sh] Loading with command: ${SKETCHYBAR_CMD:-sketchybar}"
echo "  → [apple.sh] FONT: $FONT"
echo "  → [apple.sh] ITEM_DIR: $ITEM_DIR"
echo "  → [apple.sh] PLUGIN_DIR: $PLUGIN_DIR"

POPUP_OFF="${SKETCHYBAR_CMD:-sketchybar} --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="${SKETCHYBAR_CMD:-sketchybar} --set \$NAME popup.drawing=toggle"

${SKETCHYBAR_CMD:-sketchybar} --add item           apple.logo left                             \
                                                                            \
           --set apple.logo     icon=$APPLE                                 \
                                icon.font="$FONT:Black:16.0"                \
                                icon.color=$GREEN                           \
                                background.padding_right=15                 \
                                label.drawing=off                           \
                                click_script="$POPUP_CLICK_SCRIPT"          \
                                                                            \
           --add item           apple.prefs popup.apple.logo                \
           --set apple.prefs    icon=$PREFERENCES                           \
                                label="Preferences"                         \
                                click_script="open -a 'System Preferences';
                                              $POPUP_OFF"                   \
                                                                            \
           --add item           apple.activity popup.apple.logo             \
           --set apple.activity icon=$ACTIVITY                              \
                                label="Activity"                            \
                                click_script="open -a 'Activity Monitor';
                                              $POPUP_OFF"\
                                                                            \
           --add item           apple.lock popup.apple.logo                 \
           --set apple.lock     icon=$LOCK                                  \
                                label="Lock Screen"                         \
                                click_script="pmset displaysleepnow;
                                              $POPUP_OFF"

echo "  → [apple.sh] Items created successfully"
