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

eval "$(awk '/^CORE_PACKAGES=|^MAC_PACKAGES=|^ZSHRC_LINE=/' "$ROOT/setup.sh")"

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
# Migrate the old layout, where ~/.zshrc and ~/.gitconfig linked into the repo.
ln -s dotfiles/zsh/.zshrc "$HOME/.zshrc"
ln -s dotfiles/git/.gitconfig "$HOME/.gitconfig"
OS=Darwin
stow_packages

for path in .config/zed .pi/agent; do
    test -d "$HOME/$path"
    test ! -L "$HOME/$path"
done
for path in .zshrc .gitconfig; do
    test -f "$HOME/$path"
    test ! -L "$HOME/$path"
done
grep -qxF "$ZSHRC_LINE" "$HOME/.zshrc"
env -u XDG_CONFIG_HOME git config --global test.key 1
grep -q 'key = 1' "$HOME/.gitconfig"
for path in .config/zsh/zshrc .config/git/config .pi/agent/prompts/review-pr.md; do
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
