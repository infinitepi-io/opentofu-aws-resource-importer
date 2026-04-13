#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
PROJECT_DIR="$(pwd)"
SUBMODULE_DIR="${PROJECT_DIR}/.opencode-repo"

echo "🔧 Installing opentofu-aws-resource-importer (submodule)..."
echo ""

OPENCODE_LINK="${PROJECT_DIR}/.opencode"
OPENCODE_JSON_LINK="${PROJECT_DIR}/opencode.json"

echo "   Project dir : ${PROJECT_DIR}"
echo "   Submodule   : ${SUBMODULE_DIR}"
echo ""

# ── Ensure this is a git repo ────────────────────────────────────────────────
if [ ! -d "${PROJECT_DIR}/.git" ]; then
  echo "❌ This is not a git repository. Initialize git first:"
  echo "   git init"
  exit 1
fi

# ── Add or update submodule ──────────────────────────────────────────────────
if [ -d "${SUBMODULE_DIR}/.git" ]; then
  echo "📦 Submodule exists — updating..."
  git submodule update --remote --merge
else
  if [ -d "$SUBMODULE_DIR" ]; then
    echo "❌ ${SUBMODULE_DIR} exists but is not a submodule. Aborting."
    exit 1
  fi

  echo "⬇️  Adding submodule..."
  git submodule add -b "$BRANCH" "$REPO_URL" "$SUBMODULE_DIR"
fi

# ── Symlink .opencode ────────────────────────────────────────────────────────
if [ -L "$OPENCODE_LINK" ]; then
  echo "🔗 Updating .opencode symlink..."
  ln -sf "${SUBMODULE_DIR}/.opencode" "$OPENCODE_LINK"
elif [ -d "$OPENCODE_LINK" ]; then
  echo "❌ ${OPENCODE_LINK} exists as a real directory. Aborting."
  exit 1
else
  echo "🔗 Creating .opencode symlink..."
  ln -s "${SUBMODULE_DIR}/.opencode" "$OPENCODE_LINK"
fi

# ── Symlink opencode.json ────────────────────────────────────────────────────
if [ -L "$OPENCODE_JSON_LINK" ]; then
  echo "🔗 Updating opencode.json symlink..."
  ln -sf "${SUBMODULE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
elif [ -f "$OPENCODE_JSON_LINK" ]; then
  echo "⚠️  Backing up existing opencode.json → opencode.json.bak"
  mv "$OPENCODE_JSON_LINK" "${OPENCODE_JSON_LINK}.bak"
  ln -s "${SUBMODULE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
else
  echo "🔗 Creating opencode.json symlink..."
  ln -s "${SUBMODULE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
fi

echo ""
echo "✅ Done!"
echo "   Submodule    : ${SUBMODULE_DIR}"
echo "   .opencode    : ${OPENCODE_LINK} → ${SUBMODULE_DIR}/.opencode"
echo "   opencode.json: ${OPENCODE_JSON_LINK} → ${SUBMODULE_DIR}/opencode.json"
echo ""
echo "💡 After cloning this repo elsewhere, run:"
echo "   git submodule update --init --recursive"
echo ""
echo "💡 To update later:"
echo "   git submodule update --remote --merge"
