#!/usr/bin/env zsh

# ============================================
# Instant Prompt (Powerlevel10k)
# ============================================
# Enable Powerlevel10k instant prompt. Should stay close to the top.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================
# Terminal Performance
# ============================================
# Disable Apple Terminal session restoration for speed
export SHELL_SESSIONS_DISABLE=1

# ============================================
# Oh My Zsh Configuration (Optimized)
# ============================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Using custom Catppuccin prompt below

# Only load essential plugins at startup
plugins=(
    git
    z
)

# Performance optimizations
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Much faster git status
DISABLE_AUTO_UPDATE="true"             # Update manually
ZSH_DISABLE_COMPFIX="true"            # Skip permission checks

source $ZSH/oh-my-zsh.sh

# ============================================
# Catppuccin Mocha Custom Prompt
# ============================================
# Define Catppuccin Mocha colors (true RGB)
CATPPUCCIN_BLUE=$'\e[38;2;137;180;250m'      # #89b4fa
CATPPUCCIN_MAUVE=$'\e[38;2;203;166;247m'     # #cba6f7
CATPPUCCIN_GREEN=$'\e[38;2;166;227;161m'     # #a6e3a1
CATPPUCCIN_PEACH=$'\e[38;2;250;179;135m'     # #fab387
CATPPUCCIN_TEAL=$'\e[38;2;148;226;213m'      # #94e2d5
CATPPUCCIN_YELLOW=$'\e[38;2;249;226;175m'    # #f9e2af
CATPPUCCIN_RED=$'\e[38;2;243;139;168m'       # #f38ba8
RESET=$'\e[0m'

# Git prompt function (lightweight)
git_prompt_info_custom() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo " %{${CATPPUCCIN_YELLOW}%}git:%{${CATPPUCCIN_GREEN}%}(${ref#refs/heads/})%{${RESET}%}"
}

# Set the prompt (robbyrussell style with Catppuccin colors)
setopt PROMPT_SUBST
PROMPT='%{${CATPPUCCIN_PEACH}%}➜%{${RESET}%}  %{${CATPPUCCIN_TEAL}%}%1~%{${RESET}%}$(git_prompt_info_custom) '

# ============================================
# Eza Colors (Catppuccin Mocha - Minimal)
# ============================================
export EZA_COLORS="di=38;2;203;166;247:ex=38;2;166;227;161"

# ============================================
# Path Configuration (Fast)
# ============================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# ============================================
# Environment Variables
# ============================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='/Applications/Cursor.app/Contents/MacOS/Cursor --wait'
export VISUAL='/Applications/Cursor.app/Contents/MacOS/Cursor'

# Disable Homebrew hints
export HOMEBREW_NO_ENV_HINTS=1

# ============================================
# Lazy Load Heavy Tools
# ============================================

# NVM (Lazy Load - HUGE speed improvement)
export NVM_DIR="$HOME/.nvm"
# Only load nvm when needed
nvm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}
npx() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npx "$@"
}

# Bun (Fast - load immediately)
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Pyenv (Lazy load)
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    # Lazy load pyenv
    pyenv() {
        unset -f pyenv
        eval "$(command pyenv init --path)"
        eval "$(command pyenv init -)"
        pyenv "$@"
    }
fi

# ============================================
# Applications (Fast paths only)
# ============================================
[ -d "$HOME/.codeium/windsurf" ] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# ============================================
# Fast CLI Tools (only essentials at startup)
# ============================================

# Zoxide (smart cd replacement)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    # Now you have both 'z' for smart jumps and 'cd' works normally
fi

# Bat (just export, no heavy init)
command -v bat &> /dev/null && export BAT_THEME="TwoDark"

# FZF (defer heavy configuration)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================
# Defer Plugin Loading
# ============================================

# Load heavy plugins after prompt appears
load_deferred_plugins() {
    # Load syntax highlighting and autosuggestions later
    source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
    source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

    # Load completions
    autoload -Uz compinit
    if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
        compinit
    else
        compinit -C  # Skip security check for speed
    fi
}

# Load deferred plugins after a tiny delay
(load_deferred_plugins &)

# ============================================
# Functions (Lightweight)
# ============================================

cursor() {
    open -a "Cursor" "$@"
}

# ============================================
# Aliases & Config (Fast loads only)
# ============================================

# Load aliases (should be fast)
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# Load private env (should be minimal)
[ -f "$HOME/.env.private" ] && source "$HOME/.env.private"

# ============================================
# History (Optimized settings)
# ============================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY  # Write immediately, not on exit
setopt SHARE_HISTORY

# ============================================
# Minimal Completion Settings
# ============================================
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ============================================
# Optional: Load heavy tools on demand
# ============================================

# Envman (only if you use it frequently)
# [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Local overrides
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
