#!/usr/bin/env bash

set -euo pipefail

REPO_URL="git@github.com:infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
TARGET_DIR=".opencode"

echo "Setting up .opencode..."

if [ -d "$TARGET_DIR/.git" ]; then
  echo "📦 Existing repo found. Pulling latest changes..."
  cd "$TARGET_DIR"
  git pull origin "$BRANCH"
else
  if [ -d "$TARGET_DIR" ]; then
    echo "❌ $TARGET_DIR exists but is not a git repo. Aborting."
    exit 1
  fi

  echo "⬇️ Cloning repo..."
  git clone --filter=blob:none --no-checkout "$REPO_URL" "$TARGET_DIR"

  cd "$TARGET_DIR"

  git sparse-checkout init --cone
  git sparse-checkout set .opencode opencode.json
  git checkout "$BRANCH"
fi

echo "✅ Done. .opencode is up to date."
