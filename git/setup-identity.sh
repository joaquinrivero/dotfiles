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

[commit]
    template = ~/.gitconfig.d/adobe-commit-template.txt
EOF
echo "Wrote $DIR/adobe.inc"

# Compose commit template from the adobe identity
cat > "$DIR/adobe-commit-template.txt" <<EOF


Co-authored-by: ${adobe_name} <${adobe_email}>
EOF
echo "Wrote $DIR/adobe-commit-template.txt"

echo ""
echo "Done. Identity files generated in $DIR"
