#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/infinitepi-io/opentofu-aws-resource-importer.git"
BRANCH="main"
PROJECT_DIR="$(pwd)"
DEFAULT_CLONE_DIR="${HOME}/.opentofu-aws-resource-importer"

echo "🔧 Installing opentofu-aws-resource-importer..."
echo ""

# ── Ask user where to clone (only if interactive terminal) ──────────────────
if [ -t 1 ] && [ -e /dev/tty ]; then
  read -rp "📁 Where should the repo be cloned? [${DEFAULT_CLONE_DIR}]: " USER_CLONE_DIR </dev/tty || true
else
  echo "📁 Non-interactive mode — using default: ${DEFAULT_CLONE_DIR}"
fi

CLONE_DIR="${USER_CLONE_DIR:-$DEFAULT_CLONE_DIR}"
# Expand ~ if user typed it manually
CLONE_DIR="${CLONE_DIR/#\~/$HOME}"

echo ""
echo "   Project dir : ${PROJECT_DIR}"
echo "   Clone dir   : ${CLONE_DIR}"
echo ""

OPENCODE_LINK="${PROJECT_DIR}/.opencode"
OPENCODE_JSON_LINK="${PROJECT_DIR}/opencode.json"

# ── Clone or update ──────────────────────────────────────────────────────────
if [ -d "${CLONE_DIR}/.git" ]; then
  echo "📦 Repo found at ${CLONE_DIR} — pulling latest..."
  git -C "$CLONE_DIR" pull origin "$BRANCH"
else
  echo "⬇️  Cloning into ${CLONE_DIR}..."
  git clone --branch "$BRANCH" "$REPO_URL" "$CLONE_DIR"
fi

# ── Symlink .opencode into project ───────────────────────────────────────────
if [ -L "$OPENCODE_LINK" ]; then
  echo "🔗 Updating .opencode symlink..."
  ln -sf "${CLONE_DIR}/.opencode" "$OPENCODE_LINK"
elif [ -d "$OPENCODE_LINK" ]; then
  echo "❌ ${OPENCODE_LINK} exists as a real directory. Aborting to avoid data loss."
  echo "   Back it up and remove it, then re-run."
  exit 1
else
  echo "🔗 Creating .opencode symlink..."
  ln -s "${CLONE_DIR}/.opencode" "$OPENCODE_LINK"
fi

# ── Symlink opencode.json into project root ───────────────────────────────────
if [ -L "$OPENCODE_JSON_LINK" ]; then
  echo "🔗 Updating opencode.json symlink..."
  ln -sf "${CLONE_DIR}/opencode.json" "$OPENCODE_JSON_LINK"
elif [ -f "$OPENCODE_JSON_LINK" ]; then
  echo "⚠️  ${OPENCODE_JSON_LINK} exists as a real file — backing up to opencode.json.bak"
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
