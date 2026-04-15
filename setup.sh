#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh git tmux starship aerospace sketchybar hammerspoon gh misc direnv)

echo "=== Dotfiles Setup ==="
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# Step 1: Ensure stow is installed
if ! command -v stow &> /dev/null; then
    echo "Installing GNU Stow via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "ERROR: Homebrew not found. Install it first: https://brew.sh"
        exit 1
    fi
    brew install stow
fi

# Step 2: Back up existing files that would conflict with stow
CONFLICTING_FILES=(
    "$HOME/.zshrc"
    "$HOME/.aliases"
    "$HOME/.gitconfig"
    "$HOME/.gitattributes"
    "$HOME/.tmux.conf"
    "$HOME/.editorconfig"
    "$HOME/.curlrc"
    "$HOME/.hushlogin"
    "$HOME/.config/starship.toml"
    "$HOME/.config/aerospace/aerospace.toml"
    "$HOME/.config/sketchybar"
    "$HOME/.config/hammerspoon"
    "$HOME/.config/tmux/tmux.reset.conf"
    "$HOME/.config/git/ignore"
    "$HOME/.config/gh/config.yml"
)

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
HAS_CONFLICTS=false

for f in "${CONFLICTING_FILES[@]}"; do
    if [ -e "$f" ] && [ ! -L "$f" ]; then
        HAS_CONFLICTS=true
        break
    fi
done

if [ "$HAS_CONFLICTS" = true ]; then
    echo "Backing up existing files to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    for f in "${CONFLICTING_FILES[@]}"; do
        if [ -e "$f" ] && [ ! -L "$f" ]; then
            REL_PATH="${f#$HOME/}"
            mkdir -p "$BACKUP_DIR/$(dirname "$REL_PATH")"
            mv "$f" "$BACKUP_DIR/$REL_PATH"
            echo "  Backed up: $REL_PATH"
        fi
    done
fi

# Step 3: Stow all packages
echo ""
echo "Stowing packages..."
for pkg in "${PACKAGES[@]}"; do
    echo "  Stowing: $pkg"
    stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
done

echo ""
echo "Done! All packages stowed successfully."
if [ "$HAS_CONFLICTS" = true ]; then
    echo "Backup of original files: $BACKUP_DIR"
fi
echo ""
echo "Verify with: ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf"
echo ""

# Step 4: Git identity setup
echo "=== Git Identity Setup ==="
if [ -f "$DOTFILES_DIR/git/.gitconfig.d/personal.inc" ]; then
    echo "Identity files already exist — skipping."
else
    echo "You need to configure your git identity."
    echo ""
    echo "Options:"
    echo "  1) Run the setup script:  ./git/setup-identity.sh"
    echo "  2) Let Claude Code guide you:  claude"
    echo ""
    read -rp "Run identity setup now? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        "$DOTFILES_DIR/git/setup-identity.sh"
    fi
fi
