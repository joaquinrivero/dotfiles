# Dotfiles — Claude Code Context

## What this is

macOS dotfiles managed with GNU Stow. Each top-level directory is a stow package that symlinks into `~`.

## Packages

zsh, git, tmux, starship, aerospace, sketchybar, hammerspoon, gh, misc

## First-time setup

When helping a user set up these dotfiles for the first time:

1. **Prerequisites** — Ensure Homebrew is installed. If not, guide them to install it.
2. **Run `./setup.sh`** — This installs stow, backs up conflicting files, and symlinks all packages.
3. **Git identity** — Run `./git/setup-identity.sh` to generate personal and Adobe enterprise `.inc` files and the commit template. The `.inc` files are gitignored; only `.example` templates are tracked.
4. **Local git identity** — If they only need a personal identity (no enterprise), create `~/.gitconfig.local` with `[user] name` and `email`.
5. **Private env** — Create `~/.env.private` for tokens and secrets (sourced by `.zshrc`, gitignored).
6. **Shell plugins** — zsh-autosuggestions and zsh-syntax-highlighting are expected under `~/.oh-my-zsh/custom/plugins/`. Guide installation if missing.
7. **CLI tools** — The config assumes: eza, bat, fzf, zoxide, starship. Offer to install any that are missing via `brew install`.

## Key conventions

- Identity files (`*.inc`, `adobe-commit-template.txt`) are generated, not tracked — use the `.example` files or `setup-identity.sh`.
- Secrets go in `~/.env.private`, never in tracked files.
- `~/.gitconfig.local` is the local identity override (also gitignored).
- Stow global ignore (`.stow-global-ignore`) excludes README, LICENSE, setup scripts, and .DS_Store from symlinking.

## Stow commands

```bash
stow -t ~ <package>      # symlink a package
stow -t ~ -D <package>   # remove symlinks
stow -t ~ -R <package>   # re-stow after changes
```
