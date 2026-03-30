#!/bin/bash
set -euo pipefail
# set -x

################################################################################
# Utils
################################################################################
info() {
  echo "INFO: $*"
}

die() {
  echo "ERROR: $*" >&2
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
XDG_CONFIG_GIT="$XDG_CONFIG_HOME/git"

################################################################################
# Main
################################################################################
info "setup git helpers"
# requirement
[[ "${BASH_SOURCE[0]}" == "$0" ]] || die "This script must be executed, not sourced"

source "$(abs_dirname $0)/git-helper.bash"

info "Checking git ..."
command_exists git || die "git is not installed"

################################################################################
# Git Tools
################################################################################

# diff-highlight
info "Setting diff-highlight ..."
if _HasGitDiffHighlight; then
  info "  diff-highlight is already installed"
else
  info "  install diff-highlight..."
  _InstallGitHelper "diff-highlight" "$USER_BIN" ""
  _EnableGitDiffHighlight "$USER_BIN"
fi

# Git-Prompt
info "Setting git-prompt ..."
if _HasGitPrompt; then
  info "  git-prompt.sh is already installed"
else
  info "  install git-prompt.sh..."
  _InstallGitHelper "git-prompt.sh" "$XDG_CONFIG_GIT" "https://raw.githubusercontent.com/git/git/master/contrib/completion"
  _EnableGitPrompt
fi

# Git-Completion
info "Setting git-completion ..."
if _HasGitCompletion; then
  info "  git-completion.bash is already installed"
else
  info "  install git-completion.bash ..."
  _InstallGitHelper "git-completion.bash" "$XDG_CONFIG_GIT" "https://raw.githubusercontent.com/git/git/master/contrib/completion"
  _EnableGitCompletion
fi

################################################################################
# Bash setup
################################################################################

info "Setting bash ..."

LOCAL_BIN="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

# 実行時 PATH に ~/.local/bin が含まれていない場合のみ設定を書く
case ":$PATH:" in
  *":$LOCAL_BIN:"*)
    info "  $LOCAL_BIN is already in PATH"
    ;;
  *)
    info "  Adding $LOCAL_BIN to PATH in $BASHRC"
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

info "Setting git ..."

SCRIPT_DIR="$(abs_dirname "$0")"

# ---- install ----
info "Install git config ..."
XDG_CONFIG_GITHOME="$XDG_CONFIG_HOME/git"
XDG_CONFIG_GIT="$XDG_CONFIG_GITHOME/config"
mkdir -p "$XDG_CONFIG_GITHOME"
ln -sfv "$SCRIPT_DIR/linux.conf" "$XDG_CONFIG_GIT"

# ---- gitconfig setup ----
info "Setting up git include config ..."

GITCONFIG="$HOME/.gitconfig"
touch "$GITCONFIG"

# include がすでにあるか確認
if ! git config --global --get-all include.path | grep -Fxq "$XDG_CONFIG_GIT"; then
  info "  Adding include to ~/.gitconfig"
  git config --global --add include.path "$XDG_CONFIG_GIT"
else
  info "  include section already exists in ~/.gitconfig"
fi

info "DONE!!"
