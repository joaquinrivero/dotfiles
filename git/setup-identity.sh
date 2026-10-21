#!/usr/bin/env bash
# Generate git identity .inc files and commit template from user input.
# Usage: ./git/setup-identity.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.gitconfig.d" && pwd)"

echo "=== Personal identity ==="
read -rp "Name: " personal_name
read -rp "Email: " personal_email
read -rp "GitHub username: " personal_gh

cat > "$DIR/personal.inc" <<EOF
[user]
    name = ${personal_name}
    email = ${personal_email}

[github]
    user = ${personal_gh}
EOF
echo "Wrote $DIR/personal.inc"

echo ""
echo "=== Adobe enterprise identity ==="
read -rp "Name: " adobe_name
read -rp "Corporate email: " adobe_email
read -rp "GitHub enterprise username: " adobe_gh

cat > "$DIR/adobe.inc" <<EOF
# Operational identity for pushing to Adobe GHE
[user]
    name = ${adobe_name}
    email = ${adobe_email}

[github]
    user = ${adobe_gh}
EOF
echo "Wrote $DIR/adobe.inc"

echo ""
echo "=== Adobe corp identity (git.corp.adobe.com) ==="
read -rp "Name: " corp_name
read -rp "Corporate email: " corp_email

cat > "$DIR/corp.inc" <<EOF
[user]
    name = ${corp_name}
    email = ${corp_email}
EOF
echo "Wrote $DIR/corp.inc"

echo ""
echo "Done. Identity files generated in $DIR"

# --- SSH keys + config (mechanical part only; registering keys with
# GitHub/completing gh auth login is an inherently manual browser step) ---
echo ""
echo "=== SSH keys ==="

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "${personal_gh}"
    echo "Generated ~/.ssh/id_ed25519"
else
    echo "~/.ssh/id_ed25519 already exists — skipping"
fi

if [ ! -f ~/.ssh/id_ed25519_enterprise ]; then
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_enterprise -N "" -C "${adobe_gh}"
    echo "Generated ~/.ssh/id_ed25519_enterprise"
else
    echo "~/.ssh/id_ed25519_enterprise already exists — skipping"
fi

if [ ! -f ~/.ssh/config ]; then
    cat > ~/.ssh/config <<'EOF'
# Public GitHub (personal)
Host github.com
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519

# Adobe internal GHE — reuses personal key
Host git.corp.adobe.com
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519

# Enterprise GitHub (OneAdobe)
Host github.com-enterprise
  HostName github.com
  AddKeysToAgent yes
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_ed25519_enterprise
EOF
    chmod 600 ~/.ssh/config
    echo "Wrote ~/.ssh/config"
else
    echo "~/.ssh/config already exists — leaving as-is"
fi

echo ""
echo "=== Manual steps (need a browser — can't be scripted) ==="
echo "1. Add ~/.ssh/id_ed25519.pub to https://github.com/settings/keys (${personal_gh})"
echo "2. Add ~/.ssh/id_ed25519_enterprise.pub to https://github.com/settings/keys (${adobe_gh}),"
echo "   then SSO-authorize it for each Adobe org you need (Configure SSO on that key)"
echo "3. gh auth login -h github.com -p ssh        # once per account: ${personal_gh}, ${adobe_gh}"
echo "4. Corp GHE PAT (no-expiry, gh's own token expires weekly on git.corp.adobe.com):"
echo "   create at https://git.corp.adobe.com/settings/tokens/new (scopes: repo, read:org)"
echo "   echo '<token>' | gh auth login -h git.corp.adobe.com --with-token"
