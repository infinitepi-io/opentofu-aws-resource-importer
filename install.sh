#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
TEMP_DIR="/tmp/opentofu-aws-resource-importer"
CLONE_DATE=$(date +%Y-%m-%d)

cleanup() {
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

echo "Installing opentofu-aws-resource-importer..."

# Clone to temp directory
if [ -d "$TEMP_DIR/.git" ]; then
  echo "Updating existing clone..."
  git -C "$TEMP_DIR" pull
else
  rm -rf "$TEMP_DIR"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR"
fi

# Copy files
cp -r "$TEMP_DIR/.opencode" ./
cp "$TEMP_DIR/opencode.json" .

# Update ORIGIN file with clone date
if [ -f .opencode/ORIGIN ]; then
  sed -i "s/Clone date:.*/Clone date: ${CLONE_DATE}/" .opencode/ORIGIN
fi

echo "Done! OpenCode configuration installed."