#!/bin/bash

# Cursor-based auto-hide for sketchybar
# Show bar when cursor is near the right edge, hide otherwise

SCREEN_WIDTH=$(system_profiler SPDisplaysDataType | grep "Resolution" | head -1 | awk '{print $2}')
HIDE_THRESHOLD=$((SCREEN_WIDTH - 100))  # Hide if cursor is more than 100px from right edge

while true; do
  # Get current mouse position using Python
  MOUSE_POS=$(python3 << 'EOF'
import os
os.system('clear')
try:
    from AppKit import NSEvent
    loc = NSEvent.mouseLocation()
    print(int(loc.x))
except:
    print("0")
EOF
)

  # Show bar if cursor is near right edge, otherwise hide
  if [ "$MOUSE_POS" -gt "$HIDE_THRESHOLD" ] 2>/dev/null; then
    sketchybar --bar hidden=off
  else
    sketchybar --bar hidden=on
  fi

  sleep 0.3
done
