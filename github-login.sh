#!/usr/bin/env bash
set -euo pipefail

# Ensure gh is authenticated
if ! gh auth status &>/dev/null; then
  echo "❌ Not logged into gh. Run 'gh auth login' first."
  exit 1
fi

# Ensure the 'user' scope is available
if ! gh api user/emails &>/dev/null; then
  echo "🔄 Missing 'user' scope — requesting it now..."
  gh auth refresh -h github.com -s user
fi

# Fetch GitHub username
GH_USER=$(gh api user --jq '.login')

# Prefer the noreply email, fall back to primary email
GH_EMAIL=$(gh api user/emails --jq '
  (map(select(.email | endswith("@users.noreply.github.com"))) | first // empty) //
  (map(select(.primary)) | first) |
  .email
')

if [[ -z "${GH_USER:-}" || -z "${GH_EMAIL:-}" ]]; then
  echo "❌ Could not determine GitHub username or email."
  exit 1
fi

git config --global user.name "$GH_USER"
git config --global user.email "$GH_EMAIL"

echo "✅ Git identity configured:"
echo "   user.name  = $GH_USER"
echo "   user.email = $GH_EMAIL"
