#!/usr/bin/env bash
set -euo pipefail

################################################################################
# Utils
################################################################################

info()
{
  echo "INFO: $*"
}

die()
{
  echo "ERROR: $*" >&2
  exit 1
}

abs_dirname()
{
  (
    cd "$(dirname "$1")"
    pwd -P
  )
}

################################################################################
# Config
################################################################################

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CONFIG_GIT="$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_GIT"

################################################################################
# Main
################################################################################

[[ "${BASH_SOURCE[0]}" == "$0" ]] \
  || die "This script must be executed, not sourced"

source "$(abs_dirname "$0")/git-helper.bash"

mkdir -p "$XDG_CONFIG_GIT"

################################################################################
# git-prompt
################################################################################

info "install git-prompt"

destination="$XDG_CONFIG_GIT/git-prompt.sh"
InstallGitHelper \
  "$destination" \
  "$GIT_PROMPT_URL" \
  "${GIT_PROMPT_CANDIDATES[@]}"

################################################################################
# git-completion
################################################################################

info "install git-completion"

destination="$XDG_CONFIG_GIT/git-completion.bash"
InstallGitHelper \
  "$destination" \
  "$GIT_COMPLETION_URL" \
  "${GIT_COMPLETION_CANDIDATES[@]}"

################################################################################
# diff-highlight
################################################################################

info "install diff-highlight"

destination="$XDG_CONFIG_GIT/diff-highlight"
if command -v diff-highlight > /dev/null 2>&1; then
  InstallGitHelper \
    "$destination" \
    "$DIFF_HIGHLIGHT_URL" \
    "${DIFF_HIGHLIGHT_CANDIDATES[@]}"

  chmod +x "$destination"
fi
################################################################################
# Git config setup
################################################################################

info "Setting git ..."

SCRIPT_DIR="$(abs_dirname "$0")"

# ---- install ----
info "Install git config ..."
XDG_CONFIG_GIT_CONFIG="$XDG_CONFIG_GIT/config"
ln -sfv "$SCRIPT_DIR/linux.conf" "$XDG_CONFIG_GIT_CONFIG"

info "DONE"
