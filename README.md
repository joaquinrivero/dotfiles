# dotfiles

macOS configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone git@github.com:joaquinrivero/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` installs Stow via Homebrew, backs up conflicting files to `~/.dotfiles-backup-<timestamp>/`, and symlinks all packages.

Set up your git identity after stowing:

```bash
./git/setup-identity.sh
```

To configure interactively with Claude Code:

```bash
claude
```

Claude reads `CLAUDE.md` and handles identity files, missing CLI tools, and shell plugins.

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
| `zed` | Zed editor settings and Catppuccin theme |
| `warp` | Warp terminal settings |
| `cursor` | Cursor editor settings |
| `gh` | GitHub CLI config |
| `misc` | `.editorconfig`, `.curlrc`, `.hushlogin` |
| `direnv` | Per-directory env overrides |

## How it works

Each top-level directory is a Stow package mirroring the file structure relative to `~`. `stow <package>` creates symlinks in your home directory:

```
dotfiles/zsh/.zshrc           →  ~/.zshrc
dotfiles/git/.gitconfig       →  ~/.gitconfig
dotfiles/aerospace/.config/…  →  ~/.config/aerospace/…
```

Editing files in `~/dotfiles/` updates the live config — no copy step needed.

## Managing packages

```bash
stow -t ~ git        # stow a package
stow -t ~ -D git     # remove symlinks
stow -t ~ -R git     # re-stow after adding files
cd ~/dotfiles && stow -t ~ */  # stow everything
```

## Device-specific config

Machine-specific config — tool completions, local paths, work proxies — goes in `~/.zshrc.local`. Sourced at the end of `.zshrc`, never tracked in git.

```bash
cp ~/dotfiles/zsh/.zshrc.local.example ~/.zshrc.local
# edit and uncomment what applies to this machine
```

Works the same on Linux.

## Adding a new package

1. Create a directory matching the tool name
2. Mirror the path from `~` inside it
3. Run `stow -t ~ <package>`

Example for neovim:

```bash
mkdir -p nvim/.config/nvim
cp ~/.config/nvim/init.lua nvim/.config/nvim/
stow -t ~ nvim
```
