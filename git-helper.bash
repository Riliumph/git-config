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

################################################################################
# Common
################################################################################
AppendIfNotExists()
{
  local line="$1"
  local file="$2"
  grep -Fxq "$line" "$file" 2> /dev/null || echo "$line" >> "$file"
}

_InstallGitHelper()
{
  local target="$1"    # 探すファイル名
  local dest="$2"      # コピー先ファイルパス
  local curl_base="$3" # 見つからない場合のcurlパス

  mkdir -p "$dest"
  local found
  # find DIR DIR ... CONDの手法だとARG_MAXを超えるからか失敗するケースが有る
  for dir in "${GIT_FILE_LOCATION[@]}"; do
    [[ -d "$dir" ]] || continue

    found=$(find "$dir" -type f -name "$target" -print -quit 2> /dev/null)
    [[ -n "$found" ]] && break
  done

  if [[ -n "$found" ]]; then
    echo "copy: $found -> $dest/$target"
    cp -f "$found" "$dest/$target"
  else
    echo "download: $target"
    curl -fsSL -o "$dest/$target" "$curl_base/$target"
  fi
}

################################################################################
# Git Prompt
################################################################################

_FindGitPrompt()
{
  local path

  for path in "${_GIT_PROMPT_CANDIDATES[@]}"; do
    [[ -r "$path" ]] && {
      printf '%s\n' "$path"
      return 0
    }
  done

  return 1
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

# Git Completion

# 0 (true) ならすでに定義済み
_HasGitCompletion()
{
  bash -l -i -c 'complete -p git > /dev/null 2>&1'
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
