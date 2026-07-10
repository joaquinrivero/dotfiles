#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS="$(uname -s)"

# Cross-platform: always stow (config is ready when app is installed)
CORE_PACKAGES=(zsh git tmux gh misc direnv zed)

# macOS-only apps
MAC_PACKAGES=(aerospace warp cursor)

# Ensure Homebrew is on PATH (Apple Silicon puts it at /opt/homebrew)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

echo "=== Dotfiles Setup ==="
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# Step 1: Ensure stow is installed
if ! command -v brew &> /dev/null; then
    echo "ERROR: Homebrew not found. Install it first: https://brew.sh"
    exit 1
fi

if ! command -v stow &> /dev/null; then
    echo "Installing GNU Stow via Homebrew..."
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
    "$HOME/.config/tmux/tmux.reset.conf"
    "$HOME/.config/git/ignore"
    "$HOME/.config/gh/config.yml"
    "$HOME/.config/zed/settings.json"
)

if [[ "$OS" == "Darwin" ]]; then
    CONFLICTING_FILES+=(
        "$HOME/.config/aerospace/aerospace.toml"
        "$HOME/.warp/settings.toml"
        "$HOME/Library/Application Support/Cursor/User/settings.json"
    )
fi

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

# Step 2b: Install required CLI tools
CLI_TOOLS=(eza bat fzf zoxide tmux)
echo "Checking CLI tools..."
MISSING_TOOLS=()
for tool in "${CLI_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "Installing missing tools: ${MISSING_TOOLS[*]}"
    brew install "${MISSING_TOOLS[@]}"
else
    echo "All CLI tools already installed."
fi
echo ""

# Step 3: Stow all packages
echo ""
echo "Stowing packages..."
PACKAGES=("${CORE_PACKAGES[@]}")
[[ "$OS" == "Darwin" ]] && PACKAGES+=("${MAC_PACKAGES[@]}")

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

# Step 3b: Render templated configs (envsubst replaces $HOME with the real path)
if [[ "$OS" == "Darwin" ]]; then
    echo "Rendering Warp settings template..."
    envsubst < "$DOTFILES_DIR/warp/.warp/settings.toml.template" > "$HOME/.warp/settings.toml"
    echo "  Written: ~/.warp/settings.toml"
    echo ""

    # Install Zed CLI if Zed is installed but CLI symlink is missing
    ZED_CLI="/Applications/Zed.app/Contents/MacOS/cli"
    ZED_LINK="$HOME/.local/bin/zed"
    if [ -f "$ZED_CLI" ] && [ ! -e "$ZED_LINK" ]; then
        echo "Linking Zed CLI..."
        mkdir -p "$HOME/.local/bin"
        ln -sf "$ZED_CLI" "$ZED_LINK"
        echo "  Linked: zed → $ZED_CLI"
    fi
fi

# Step 4: Fonts
echo "=== Fonts ==="
if [[ "$OS" == "Darwin" ]]; then
    if ! ls ~/Library/Fonts/HackNerdFont* &>/dev/null; then
        echo "Installing Hack Nerd Font..."
        brew install --cask font-hack-nerd-font
    else
        echo "Hack Nerd Font already installed — skipping."
    fi
elif [[ "$OS" == "Linux" ]]; then
    if ! fc-list 2>/dev/null | grep -qi "Hack Nerd Font"; then
        echo "Installing Hack Nerd Font..."
        FONT_VERSION="v3.2.1"
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/Hack.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        curl -fsSL "$FONT_URL" -o /tmp/HackNerdFont.zip && \
            unzip -o /tmp/HackNerdFont.zip -d "$FONT_DIR" '*.ttf' && \
            fc-cache -fv && \
            rm /tmp/HackNerdFont.zip
    else
        echo "Hack Nerd Font already installed — skipping."
    fi
fi

# Step 5: Terminal settings
echo ""
echo "=== Terminal Settings ==="
TERMINAL_PLIST="$DOTFILES_DIR/terminal/terminal.plist"
if [[ "$OS" == "Darwin" ]] && [ -f "$TERMINAL_PLIST" ]; then
    echo "Importing Terminal preferences (theme, font, profile)..."
    # Quit Terminal first so it doesn't overwrite the import on exit
    osascript -e 'tell application "Terminal" to quit' 2>/dev/null || true
    sleep 1
    defaults import com.apple.Terminal "$TERMINAL_PLIST"
    echo "  Done. Reopen Terminal to see the changes."
else
    echo "Terminal plist not found — skipping."
fi

# Step 6: Git identity setup
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

# Step 7: Agentics skills repo + credentials
echo ""
echo "=== Agentics Setup ==="
if [ -d "$HOME/src/agentics/.git" ] && [ -f "$HOME/.agentics/credentials" ]; then
    echo "Skills repo and credentials already present — skipping."
else
    read -rp "Set up agentics skills repo and credentials now? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        "$DOTFILES_DIR/agentics/setup-agentics.sh"
    fi
fi
