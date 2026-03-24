#!/bin/bash

# Kill any existing instances
pkill -9 sketchybar 2>/dev/null
pkill -9 borders 2>/dev/null
sleep 1

# Start both sketchybar instances with their respective configs
sketchybar_builtin --config ~/.config/sketchybar/sketchybarrc_builtin &
sleep 0.5
sketchybar_samsung --config ~/.config/sketchybar/sketchybarrc_samsung &
sleep 1

# Ensure positions are correctly set
sketchybar_builtin --bar position=right display=2
sketchybar_samsung --bar position=left display=1

# Start borders
borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0 &

# Wait for everything to start
sleep 2

# Verify all processes are running
echo "Checking running processes..."
if pgrep -f "sketchybar_builtin" > /dev/null; then
    echo "✓ sketchybar_builtin is running"
else
    echo "✗ sketchybar_builtin failed to start"
fi

if pgrep -f "sketchybar_samsung" > /dev/null; then
    echo "✓ sketchybar_samsung is running"
else
    echo "✗ sketchybar_samsung failed to start"
fi

if pgrep -f "borders" > /dev/null; then
    echo "✓ borders is running"
else
    echo "✗ borders failed to start"
fi

echo ""
echo "Dual sketchybar setup complete!"
