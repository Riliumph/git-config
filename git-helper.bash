################################################################################
# GLOBAL CONFIG
################################################################################

# `$ grep -R "git-sh-prompt" /etc/profile /etc/bash.bashrc /etc/profile.d /etc/bash_completion.d 2>/dev/null``
_GIT_PROMPT_CANDIDATES=(
  ## Linux
  # load in /etc/bash_completion.d/git-prompt
  "/usr/lib/git-core/git-sh-prompt"
  "/usr/share/git/completion/git-prompt.sh"
  ## macOS
  # Homebrew(intel)
  "/usr/local/share/git-core/contrib/completion/git-prompt.sh"
  "/usr/local/etc/bash_completion.d/git-prompt.sh"
  "/usr/local/opt/git/etc/bash_completion.d/git-prompt.sh"
  # Homebrew(AppleSilicon)
  "/opt/homebrew/share/git-core/contrib/completion/git-prompt.sh"
  "/opt/homebrew/etc/bash_completion.d/git-prompt.sh"
  "/opt/homebrew/opt/git/etc/bash_completion.d/git-prompt.sh"
  # MacPorts
  "/opt/local/share/git-core/contrib/completion/git-prompt.sh"
  "/opt/local/etc/bash_completion.d/git-prompt.sh"
  # XCode
  "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh"
  "/Applications/Xcode.app/Contents/Developer/usr/share/git-core/contrib/completion/git-prompt.sh"
  "/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh"
  "/Library/Developer/CommandLineTools/usr/share/git-core/contrib/completion/git-prompt.sh"
)

# `$ grep -R "bash_completion" /etc/profile /etc/bash.bashrc /etc/profile.d /etc/bash_completion.d 2>/dev/null`
_GIT_COMPLETION_CANDIDATES=(
  ## Linux
  # load in /etc/bash.bashrc
  "/usr/share/bash-completion/completions/git"
  "/usr/share/git/completion/git-completion.bash"
  ## macOS
)

_GIT_DIFF_HIGHLIGHTS=(
  "/usr/share/doc/git/contrib/diff-highlight/diff-highlight"
)

################################################################################
# Common
################################################################################
AppendIfNotExists()
{
  local line="$1"
  local file="$2"
  grep -Fxq "$line" "$file" 2> /dev/null || echo "$line" >> "$file"
}

_FindFile()
{
  local -n candidates="$1"

  local path
  for path in "${candidates[@]}"; do
    [[ -r "$path" ]] || continue

    printf '%s\n' "$path"
    return 0
  done

  return 1
}

_EnsureFile()
{
  local find_func="$1"
  local dest="$2"
  local url="$3"

  local path

  mkdir -p "$(dirname "$dest")"

  if path=$("$find_func"); then
    info "  found: $path"
    cp -f "$path" "$dest"
  else
    info "  download: $(basename "$dest")"
    curl -fsSL -o "$dest" "$url"
  fi
}

################################################################################
# Git Prompt
################################################################################

_FindGitPrompt()
{
  _FindFile _GIT_PROMPT_CANDIDATES
}

_EnableGitPrompt()
{
  local gp="${XDG_CONFIG_GIT}/git-prompt.sh"

  if [[ -r "$gp" ]]; then
    AppendIfNotExists "source \"$gp\"" "$HOME/.bashrc"
  else
    echo "git-prompt.sh not found: $gp"
  fi
}

################################################################################
# Git Completion
################################################################################

_FindGitCompletion()
{
  _FindFile _GIT_COMPLETION_CANDIDATES
}

_EnableGitCompletion()
{
  local gc="${XDG_CONFIG_GIT}/git-completion.bash"

  if [[ -r "$gc" ]]; then
    AppendIfNotExists "source \"$gc\"" "$HOME/.bashrc"
  else
    echo "git-completion.bash not found: $gc"
  fi
}

################################################################################
# Git diff-highlight
################################################################################

_FindGitDiffHighlight()
{
  _FindFile _GIT_DIFF_HIGHLIGHTS
}

# 0 (true) ならすでに定義済み
_HasGitDiffHighlight()
{
  # commandを探す場合、commandコマンドで十分
  command -v diff-highlight &> /dev/null
}

_EnableGitDiffHighlight()
{
  chmod +x "$1/diff-highlight"
}
