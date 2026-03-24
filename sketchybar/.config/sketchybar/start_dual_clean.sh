#!/bin/bash

# Kill any existing instances
pkill -9 sketchybar 2>/dev/null
pkill -9 borders 2>/dev/null
sleep 1

# Start sketchybar instances
sketchybar_builtin --config ~/.config/sketchybar/sketchybarrc_builtin &
sleep 0.5
sketchybar_samsung --config ~/.config/sketchybar/sketchybarrc_samsung &
sleep 1.5

# Start borders
borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 &

sleep 2

# Verify
echo "✓ Dual sketchybar setup complete"
pgrep -f "sketchybar_builtin" > /dev/null && echo "  • sketchybar_builtin running"
pgrep -f "sketchybar_samsung" > /dev/null && echo "  • sketchybar_samsung running"
pgrep -f "borders" > /dev/null && echo "  • borders running"
