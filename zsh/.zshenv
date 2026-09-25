. "$HOME/.cargo/env"

# nvm's default node ahead of Homebrew's on PATH — loads even in shells that
# skip .zshrc (stale panes, non-interactive `zsh -c`), so `node`/`npm` never
# silently fall through to Homebrew's version.
export PATH="$HOME/.nvm/versions/node/v22.15.1/bin:$PATH"

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
