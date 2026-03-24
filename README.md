# dotfiles

Personal macOS configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone https://github.com/joaquinrivero/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` will install Stow (via Homebrew if needed), back up any existing config files to `~/.dotfiles-backup-<timestamp>/`, and create symlinks for all packages.

After setup, create your local git identity (not tracked by the repo):

```bash
cat > ~/.gitconfig.local << 'EOF'
[user]
	name = Your Name
	email = your@email.com
EOF
```

## Packages

| Package | What it manages |
|---------|----------------|
| `zsh` | `.zshrc`, `.aliases` |
| `git` | `.gitconfig`, `.gitattributes`, `.config/git/ignore` |
| `tmux` | `.tmux.conf`, `.config/tmux/tmux.reset.conf` |
| `aerospace` | AeroSpace tiling window manager |
| `sketchybar` | Custom macOS menu bar |
| `hammerspoon` | macOS automation (Spoons included) |
| `starship` | Cross-shell prompt (Catppuccin Mocha) |
| `gh` | GitHub CLI config |
| `misc` | `.editorconfig`, `.curlrc`, `.hushlogin` |

## How it works

Each top-level directory is a Stow package that mirrors the file structure relative to `~`. Running `stow <package>` from the repo creates symlinks in your home directory:

```
dotfiles/zsh/.zshrc           →  ~/.zshrc
dotfiles/git/.gitconfig       →  ~/.gitconfig
dotfiles/aerospace/.config/…  →  ~/.config/aerospace/…
```

Editing files in `~/dotfiles/` changes the live config directly — no copy or sync step needed.

## Managing packages

```bash
# Stow a single package
stow -t ~ git

# Unstow (remove symlinks)
stow -t ~ -D git

# Re-stow (useful after adding files to a package)
stow -t ~ -R git

# Stow everything
cd ~/dotfiles && stow -t ~ */
```

## Adding a new package

1. Create a directory matching the tool name
2. Mirror the path from `~` inside it
3. Run `stow -t ~ <package>`

Example for neovim:
```
mkdir -p nvim/.config/nvim
cp ~/.config/nvim/init.lua nvim/.config/nvim/
stow -t ~ nvim
```
