#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
PROJECT_DIR="$(pwd)"
CLONE_DIR="${PROJECT_DIR}/.opencode-repo"

echo "🔧 Installing opentofu-aws-resource-importer..."
echo ""

OPENCODE_LINK="${PROJECT_DIR}/.opencode"
OPENCODE_JSON_LINK="${PROJECT_DIR}/opencode.json"

echo "   Project dir : ${PROJECT_DIR}"
echo "   Clone dir   : ${CLONE_DIR}"
echo ""

# ── Clone or update ──────────────────────────────────────────────────────────
if [ -d "${CLONE_DIR}/.git" ]; then
  echo "📦 Repo found — updating..."
  git -C "$CLONE_DIR" fetch origin "$BRANCH"
  git -C "$CLONE_DIR" reset --hard "origin/$BRANCH"
else
  if [ -d "$CLONE_DIR" ]; then
    echo "❌ ${CLONE_DIR} exists but is not a git repo. Aborting."
    exit 1
  fi

  echo "⬇️  Cloning into ${CLONE_DIR}..."
  git clone --branch "$BRANCH" "$REPO_URL" "$CLONE_DIR"
fi

# ── Symlink .opencode ────────────────────────────────────────────────────────
if [ -L "$OPENCODE_LINK" ]; then
  echo "🔗 Updating .opencode symlink..."
  ln -sf "${CLONE_DIR}/.opencode" "$OPENCODE_LINK"
elif [ -d "$OPENCODE_LINK" ]; then
  echo "❌ ${OPENCODE_LINK} exists as a real directory. Aborting."
  exit 1
else
  echo "🔗 Creating .opencode symlink..."
  ln -s "${CLONE_DIR}/.opencode" "$OPENCODE_LINK"
fi

# ── Symlink opencode.json ────────────────────────────────────────────────────
if [ -L "$OPENCODE_JSON_LINK" ]; then
  echo "🔗 Updating opencode.json symlink..."
  ln -sf "${CLONE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
elif [ -f "$OPENCODE_JSON_LINK" ]; then
  echo "⚠️  Backing up existing opencode.json → opencode.json.bak"
  mv "$OPENCODE_JSON_LINK" "${OPENCODE_JSON_LINK}.bak"
  ln -s "${CLONE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
else
  echo "🔗 Creating opencode.json symlink..."
  ln -s "${CLONE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
fi

echo ""
echo "✅ Done!"
echo "   Repo         : ${CLONE_DIR}"
echo "   .opencode    : ${OPENCODE_LINK} → ${CLONE_DIR}/.opencode"
echo "   opencode.json: ${OPENCODE_JSON_LINK} → ${CLONE_DIR}/opencode.json"
echo ""
echo "💡 To update later: git -C ${CLONE_DIR} pull"
