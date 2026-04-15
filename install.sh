#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
TEMP_DIR=$(mktemp -d)
CLONE_DATE=$(date +%Y-%m-%d)

echo "Installing opentofu-aws-resource-importer..."

# Clone to temp directory
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR"

# Copy files
cp -r "$TEMP_DIR/.opencode" ./
cp "$TEMP_DIR/opencode.json" .

# Update ORIGIN file with clone date
if [ -f .opencode/ORIGIN ]; then
  sed -i "s/Clone date:.*/Clone date: ${CLONE_DATE}/" .opencode/ORIGIN
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo "Done! OpenCode configuration installed."