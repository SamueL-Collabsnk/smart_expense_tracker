#!/usr/bin/env bash
# Usage: ./scripts/push_to_github.sh <git-remote-url>
# Example: ./scripts/push_to_github.sh git@github.com:yourusername/expense_tracker.git

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <git-remote-url>"
  exit 1
fi

REMOTE_URL="$1"

echo "Setting up git repository and pushing to: $REMOTE_URL"

if [ ! -d .git ]; then
  git init
  echo "Initialized new git repository"
fi

git add .
git commit -m "chore: initial commit" || echo "No changes to commit"

git branch -M main || true
if git remote | grep origin >/dev/null 2>&1; then
  git remote remove origin
fi
git remote add origin "$REMOTE_URL"

echo "Pushing to remote..."
git push -u origin main

echo "Done. If authentication fails, ensure you have SSH keys set up or use HTTPS and provide credentials."
