Guide the user through first-time dotfiles setup, step by step. Be conversational and check what's already done before suggesting actions.

## Steps

### 1. Prerequisites
Check if these are installed and offer to install any that are missing:
- Homebrew (`brew`)
- GNU Stow (`stow`)

### 2. Stow packages
Check if `./setup.sh` has already been run by testing if `~/.zshrc` is a symlink pointing into this repo.
- If not yet run, explain what it does and offer to run it.
- If already stowed, confirm and move on.

### 3. Git identity
Check if `git/.gitconfig.d/personal.inc` exists.
- If not, ask the user for their details (name, email, GitHub username) and whether they need an enterprise (Adobe) identity too.
- Generate the `.inc` files and commit template using `./git/setup-identity.sh` or by writing them directly from the answers.
- If the files already exist, show the current identity with `git config user.name` / `git config user.email` and confirm it's correct.

### 4. Private environment
Check if `~/.env.private` exists.
- If not, create an empty one and explain it's where tokens and secrets go (e.g., `GITHUB_TOKEN`, API keys).
- If it exists, skip.

### 5. Shell plugins
Check if zsh-autosuggestions and zsh-syntax-highlighting are installed under `~/.oh-my-zsh/custom/plugins/`.
- Offer to install any that are missing via git clone.

### 6. CLI tools
Check which of these are installed: `eza`, `bat`, `fzf`, `zoxide`, `starship`.
- Offer to install any missing ones via `brew install`.

### 7. Verify
- Run `source ~/.zshrc` or suggest opening a new terminal.
- Show a summary of what was configured.

## Guidelines
- Ask the user before running anything — don't assume.
- Skip steps that are already complete.
- If something fails, diagnose and suggest a fix rather than silently moving on.
