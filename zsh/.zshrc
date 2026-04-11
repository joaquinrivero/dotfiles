#!/usr/bin/env zsh

# ============================================
# Terminal Performance
# ============================================
export SHELL_SESSIONS_DISABLE=1

# ============================================
# Completion Setup
# ============================================
# Fix: homebrew git completion calls pkg-config (12s timeout) — bypass it
zstyle ':completion:*:*:git:*' script /opt/homebrew/share/zsh/site-functions/git-completion.bash

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
# Rebuild dump once per day, use cache otherwise
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ============================================
# Key Bindings
# ============================================
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[^[[C' forward-word
bindkey '^[^[[D' backward-word

# ============================================
# Catppuccin Mocha Prompt
# ============================================
CATPPUCCIN_GREEN=$'\e[38;2;166;227;161m'
CATPPUCCIN_PEACH=$'\e[38;2;250;179;135m'
CATPPUCCIN_TEAL=$'\e[38;2;148;226;213m'
CATPPUCCIN_YELLOW=$'\e[38;2;249;226;175m'
RESET=$'\e[0m'

git_prompt_info_custom() {
  local ref
  ref=$(command git symbolic-ref HEAD 2>/dev/null) || \
  ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
  echo " %{${CATPPUCCIN_YELLOW}%}git:%{${CATPPUCCIN_GREEN}%}(${ref#refs/heads/})%{${RESET}%}"
}

setopt PROMPT_SUBST
PROMPT='%{${CATPPUCCIN_PEACH}%}➜%{${RESET}%}  %{${CATPPUCCIN_TEAL}%}%1~%{${RESET}%}$(git_prompt_info_custom) '

# ============================================
# Eza Colors
# ============================================
export EZA_COLORS="di=38;2;203;166;247:ex=38;2;166;227;161"

# ============================================
# Path & Environment
# ============================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='/Applications/Cursor.app/Contents/MacOS/Cursor --wait'
export VISUAL='/Applications/Cursor.app/Contents/MacOS/Cursor'
export HOMEBREW_NO_ENV_HINTS=1
export BAT_THEME="TwoDark"

# ============================================
# NVM (Lazy Load)
# ============================================
export NVM_DIR="$HOME/.nvm"
nvm()  { unset -f nvm node npm npx pi; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"; nvm "$@" }
node() { unset -f nvm node npm npx pi; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@" }
npm()  { unset -f nvm node npm npx pi; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@" }
npx()  { unset -f nvm node npm npx pi; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@" }
pi()   { unset -f nvm node npm npx pi; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; pi "$@" }

# ============================================
# Bun
# ============================================
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# ============================================
# Pyenv (Lazy Load)
# ============================================
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    pyenv() { unset -f pyenv; eval "$(command pyenv init --path)"; eval "$(command pyenv init -)"; pyenv "$@" }
fi

# ============================================
# Applications
# ============================================
[ -d "$HOME/.codeium/windsurf" ] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# ============================================
# Tools
# ============================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================
# Plugins (direct, no OMZ overhead)
# ============================================
_ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"
[ -f "$_ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$_ZSH_CUSTOM/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$_ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$_ZSH_CUSTOM/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
unset _ZSH_CUSTOM

# ============================================
# Functions
# ============================================
cursor() { open -a "Cursor" "$@" }

# ============================================
# Aliases & Private Env
# ============================================
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"
[ -f "$HOME/.gitfunctions" ] && source "$HOME/.gitfunctions"
[ -f "$HOME/.env.private" ] && source "$HOME/.env.private"

# ============================================
# History
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY SHARE_HISTORY

# ============================================
# Local overrides
# ============================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Figma CLI
alias fig-start='/Users/rivero/ai/figma-cli/bin/fig-start'

# zoxide must be initialized last
export _ZO_DOCTOR=0
eval "$(zoxide init zsh)"
