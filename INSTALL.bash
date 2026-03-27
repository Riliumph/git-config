#!/bin/bash
set -euo pipefail

################################################################################
# Utils
################################################################################

die() {
  echo "Error: $*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

abs_dirname() {
  local path
  path="$(cd "$(dirname "$1")" && pwd -P)"
  echo "$path"
}

################################################################################
# Config
################################################################################

USER_BIN="$HOME/.local/bin"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

################################################################################
# Main
################################################################################

echo "Checking git ..."
command_exists git || die "git is not installed"

################################################################################
# diff-highlight
################################################################################

echo "Setting diff-highlight ..."

if ! command_exists diff-highlight; then
  echo "  Searching diff-highlight ..."

  diff_highlight_path="$(
    find /usr/share -type f -name diff-highlight 2>/dev/null | head -n 1
  )"

  if [[ -z "$diff_highlight_path" ]]; then
    die "diff-highlight not found under /usr/share"
  fi

  echo "  Linking diff-highlight ..."
  mkdir -p "$USER_BIN"
  cp -f "$diff_highlight_path" "$USER_BIN/diff-highlight"
  chmod +x "$USER_BIN/diff-highlight"
fi

################################################################################
# Bash setup
################################################################################

echo "Setting bash ..."

LOCAL_BIN="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

# 実行時 PATH に ~/.local/bin が含まれていない場合のみ設定を書く
case ":$PATH:" in
  *":$LOCAL_BIN:"*)
    echo "  $LOCAL_BIN is already in PATH"
    ;;
  *)
    echo "  Adding $LOCAL_BIN to PATH in $BASHRC"
    cat >>"$BASHRC" <<'EOF'

# Add ~/.local/bin to PATH if not already present
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
EOF
    ;;
esac


################################################################################
# Git config setup
################################################################################

echo "Install git config ..."
mkdir -p "$XDG_CONFIG_HOME/git"

SCRIPT_DIR="$(abs_dirname "$0")"
ln -sfv "$SCRIPT_DIR/linux.conf" "$XDG_CONFIG_HOME/git/config"

echo "Setting up git include config ..."

GITCONFIG="$HOME/.gitconfig"
XDG_GITCONFIG="$XDG_CONFIG_HOME/git/config"

# ~/.gitconfig がなければ作る
touch "$GITCONFIG"

# include がすでにあるか確認
if ! git config --global --get-all include.path | grep -Fxq "$XDG_GITCONFIG"; then
  echo "  Adding include to ~/.gitconfig"
  git config --global --add include.path "$XDG_GITCONFIG"
else
  echo "  include section already exists in ~/.gitconfig"
fi

echo "DONE!!"
