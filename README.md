# dotfiles

macOS configuration managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone git@github.com:joaquinrivero/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` installs Stow via Homebrew, backs up conflicting files to `~/.dotfiles-backup-<timestamp>/`, and symlinks the enabled packages.

Set up your git identity after stowing:

```bash
./git/setup-identity.sh
```

To configure interactively with Claude Code:

```bash
claude
```

Claude Code v2.1.277+ reads `AGENTS.md` and handles identity files, missing CLI tools, and shell plugins.

## Packages

| Package | What it manages |
|---------|----------------|
| `zsh` | `.zshrc`, `.aliases` |
| `git` | `.gitconfig`, `.gitattributes`, `.config/git/ignore` |
| `aerospace` | AeroSpace tiling window manager |
| `zed` | Zed editor settings and Catppuccin theme |
| `warp` | Warp terminal settings |
| `cursor` | Cursor editor settings |
| `gh` | GitHub CLI config |
| `misc` | `.editorconfig`, `.curlrc`, `.hushlogin` |
| `pi` | Pi agent settings, prompt, theme, and review template |
| `omp` | OMP agent settings, LSP config, and theme |

`setup.sh` enables `zsh git gh misc zed pi omp`. App packages in `MAC_PACKAGES` are optional.
`macos/` and `terminal/` contain scripts and imported preferences, not Stow packages.

## How it works

Each Stow package mirrors the file structure relative to `~`. Stow links individual config files, keeping app-created runtime files outside the repository:

```
dotfiles/zsh/.zshrc           →  ~/.zshrc
dotfiles/git/.gitconfig       →  ~/.gitconfig
dotfiles/aerospace/.config/…  →  ~/.config/aerospace/…
```

Editing files in `~/dotfiles/` updates the live config — no copy step needed.

## Managing packages

```bash
cd ~/dotfiles
stow --no-folding -t ~ git     # stow a package
stow -t ~ -D git               # remove symlinks
stow --no-folding -t ~ -R git  # re-stow after adding files
stow --no-folding -t ~ -R zsh git gh misc zed pi omp  # enabled packages
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
3. Run `stow --no-folding -t ~ <package>`

Example for neovim:

```bash
mkdir -p nvim/.config/nvim
cp ~/.config/nvim/init.lua nvim/.config/nvim/
stow --no-folding -t ~ nvim
```

Run the isolated Stow checks with `bash tests/stow.sh`.
