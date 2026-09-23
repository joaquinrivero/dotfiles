#!/usr/bin/env bash
# Reduce macOS animations for snappier UI. Opt-in: run on the machine you want tweaked.
#   ./macos/performance.sh          apply
#   ./macos/performance.sh --revert restore defaults
set -euo pipefail

if [[ "${1:-}" == "--revert" ]]; then
    defaults delete com.apple.universalaccess reduceMotion 2>/dev/null || true
    defaults delete com.apple.universalaccess reduceTransparency 2>/dev/null || true
    defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || true
    defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null || true
    defaults delete NSGlobalDomain NSScrollAnimationEnabled 2>/dev/null || true
    defaults delete NSGlobalDomain NSToolbarTitleViewRolloverDelay 2>/dev/null || true
    defaults delete com.apple.dock 2>/dev/null || true
    defaults delete com.apple.finder DisableAllAnimations 2>/dev/null || true
    defaults delete -g QLPanelAnimationDuration 2>/dev/null || true
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false' 2>/dev/null || true
    killall Dock Finder 2>/dev/null || true
    echo "reverted — log out to fully restore; wallpaper: reset in System Settings"
    exit 0
fi

# Accessibility: cut motion + transparency (biggest perceived speedup)
defaults write com.apple.universalaccess reduceMotion -bool true
defaults write com.apple.universalaccess reduceTransparency -bool true

# Global window/sheet animations off, instant resize
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Dock: no autohide delay, instant show/hide, no launch bounce, fast Mission Control
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock mineffect -string scale

# Finder: no animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Quick Look: instant open
defaults write -g QLPanelAnimationDuration -float 0

# Dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true' 2>/dev/null || true

# Solid dark desktop (#1e1e2e) instead of a photo wallpaper (less GPU/compositing)
WALL="$HOME/.local/share/wallpaper-solid.png"
mkdir -p "$(dirname "$WALL")"
base64 -d > "$WALL" <<'PNG'
iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAEUlEQVR42mOQk9PDihiGlgQAV14ageHD99gAAAAASUVORK5CYII=
PNG
osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALL\"" 2>/dev/null || true

killall Dock Finder 2>/dev/null || true
echo "applied — log out to fully activate reduceMotion/reduceTransparency"
