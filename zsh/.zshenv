[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# nvm's default node ahead of Homebrew's on PATH — loads even in shells that
# skip .zshrc (stale panes, non-interactive `zsh -c`), so `node`/`npm` never
# silently fall through to Homebrew's version.
# Pinned on the Mac. Elsewhere, fall back to the newest installed nvm node.
_nb="$HOME/.nvm/versions/node/v22.15.1/bin"
[ -d "$_nb" ] || _nb=("$HOME"/.nvm/versions/node/*/bin(Nn[-1]))
[ -d "$_nb" ] && export PATH="$_nb:$PATH"
unset _nb

# Launch pi with the agentics vault loaded (scoped to pi's process only, so
# FIGMA_TOKEN etc. reach extensions without polluting the shell env). Lives in
# .zshenv, not .zshrc: a pi started from a non-interactive zsh (another agent,
# a GUI/launchd task, a stale pane) otherwise gets none of these vars.
pi() {
  ( set -a
    [ -f "$HOME/.agentics/credentials" ] && . "$HOME/.agentics/credentials"
    set +a
    exec command pi "$@" )
}
