#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

DOTFILES_DIR="$WORK/dotfiles"
export HOME="$WORK/home"
mkdir -p "$DOTFILES_DIR" "$HOME/.config"

# Copy tracked configs, not local identities or runtime state.
while IFS= read -r -d '' path; do
    mkdir -p "$DOTFILES_DIR/$(dirname "$path")"
    cp "$ROOT/$path" "$DOTFILES_DIR/$path"
done < <(git -C "$ROOT" ls-files -z)

eval "$(awk '/^CORE_PACKAGES=|^MAC_PACKAGES=/' "$ROOT/setup.sh")"

stow_packages() {
    # Exercise the real setup stage without installers or network access.
    eval "$(awk '
        /^# Step 3: Stow all packages/ {copy=1}
        /^# gh-dash/ {copy=0}
        copy
    ' "$ROOT/setup.sh")"
}

# Repair an existing folded directory as well as a fresh install.
ln -s ../../dotfiles/zed/.config/zed "$HOME/.config/zed"
OS=Darwin
stow_packages

for path in .config/zed .pi/agent .omp/agent; do
    test -d "$HOME/$path"
    test ! -L "$HOME/$path"
done
for path in .zshrc .gitconfig .pi/agent/prompts/review-pr.md .omp/agent/config.yml .omp/agent/lsp.json .omp/agent/themes/catppuccin-mocha.json; do
    test -L "$HOME/$path"
    test -f "$HOME/$path"
done
for path in "${PACKAGES[@]}" setup.sh setup-identity.sh test-colors.sh; do
    test ! -e "$HOME/$path"
    test ! -L "$HOME/$path"
done

mkdir -p "$HOME/.config/zed/prompts" "$HOME/.pi/agent/sessions"
printf 'runtime\n' > "$HOME/.config/zed/prompts/state"
printf 'session\n' > "$HOME/.pi/agent/sessions/state"
OS=Linux
stow_packages

test "$(< "$HOME/.config/zed/prompts/state")" = runtime
test "$(< "$HOME/.pi/agent/sessions/state")" = session
test ! -e "$DOTFILES_DIR/zed/.config/zed/prompts"
test ! -e "$DOTFILES_DIR/pi/.pi/agent/sessions"
printf 'Stow regression checks passed (Darwin and Linux package selection).\n'
