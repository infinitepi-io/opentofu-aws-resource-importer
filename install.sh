#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
PROJECT_DIR="$(pwd)"
SUBMODULE_NAME=".opencode-repo"
SUBMODULE_DIR="${PROJECT_DIR}/${SUBMODULE_NAME}"

echo "🔧 Installing opentofu-aws-resource-importer (submodule)..."
echo ""

OPENCODE_LINK="${PROJECT_DIR}/.opencode"
OPENCODE_JSON_LINK="${PROJECT_DIR}/opencode.json"

echo "   Project dir : ${PROJECT_DIR}"
echo "   Submodule   : ${SUBMODULE_DIR}"
echo ""

# ── Ensure git repo ──────────────────────────────────────────────────────────
if [ ! -d "${PROJECT_DIR}/.git" ]; then
  echo "❌ Not a git repo. Run: git init"
  exit 1
fi

# ── FULL CLEANUP (fix broken states) ─────────────────────────────────────────
echo "🧹 Cleaning any broken submodule state..."

# remove from git config
git config --remove-section "submodule.${SUBMODULE_NAME}" 2>/dev/null || true

# remove from .gitmodules
if [ -f .gitmodules ]; then
  git config -f .gitmodules --remove-section "submodule.${SUBMODULE_NAME}" 2>/dev/null || true
fi

# remove cached index
git rm --cached "${SUBMODULE_NAME}" 2>/dev/null || true

# remove module metadata
rm -rf ".git/modules/${SUBMODULE_NAME}"

# remove working dir if broken
if [ -d "$SUBMODULE_DIR" ] && [ ! -d "$SUBMODULE_DIR/.git" ]; then
  rm -rf "$SUBMODULE_DIR"
fi

# ── Add or update submodule ──────────────────────────────────────────────────
if [ -d "${SUBMODULE_DIR}/.git" ]; then
  echo "📦 Submodule exists — updating..."
  git -C "$SUBMODULE_DIR" fetch origin "$BRANCH"
  git -C "$SUBMODULE_DIR" reset --hard "origin/$BRANCH"
else
  echo "⬇️ Adding submodule..."
  git submodule add -b "$BRANCH" "$REPO_URL" "$SUBMODULE_NAME"
  git submodule update --init --recursive
fi

# ── Symlink .opencode ────────────────────────────────────────────────────────
if [ -L "$OPENCODE_LINK" ]; then
  ln -sf "${SUBMODULE_DIR}/.opencode" "$OPENCODE_LINK"
elif [ -d "$OPENCODE_LINK" ]; then
  echo "❌ ${OPENCODE_LINK} exists as directory"
  exit 1
else
  ln -s "${SUBMODULE_DIR}/.opencode" "$OPENCODE_LINK"
fi

# ── Symlink opencode.json ────────────────────────────────────────────────────
if [ -L "$OPENCODE_JSON_LINK" ]; then
  ln -sf "${SUBMODULE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
elif [ -f "$OPENCODE_JSON_LINK" ]; then
  mv "$OPENCODE_JSON_LINK" "${OPENCODE_JSON_LINK}.bak"
  ln -s "${SUBMODULE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
else
  ln -s "${SUBMODULE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
fi

echo ""
echo "✅ Done!"
echo ""
echo "💡 Clone users must run:"
echo "   git submodule update --init --recursive"
echo ""
echo "💡 Update later:"
echo "   git submodule update --remote --merge"
