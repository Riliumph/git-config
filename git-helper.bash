################################################################################
# GLOBAL CONFIG
################################################################################
GIT_FILE_LOCATION=(
  # 共通
  "/usr/share"
  "/usr/local/share"
  # Git の contrib
  "/usr/share/git-core"
  "/usr/share/git-core/contrib/completion"
  # bash-completion の標準配置
  "/etc/bash_completion.d"
  "/usr/share/bash-completion"
  "/usr/share/bash-completion/completions"
  # Homebrew (Intel / Apple Silicon)
  "/usr/local/opt"
  "/usr/local/share/git-core/contrib/completion"
  "/opt/homebrew/opt"
  "/opt/homebrew/share/git-core/contrib/completion"
  "/opt/homebrew/etc/bash_completion.d"
  # MacPorts
  "/opt/local/share/git-core/contrib/completion"
  "/opt/local/etc/bash_completion.d"
  # Xcode / CLT（インストールしている場合）
  "/Applications/Xcode.app/Contents/Developer/usr/share/git-core"
  "/Library/Developer/CommandLineTools/usr/share/git-core"
)

################################################################################
# Utils
################################################################################

_InstallGitHelper() {
  local target="$1"      # 探すファイル名
  local dest="$2"        # コピー先ファイルパス
  local curl_base="$3"   # 見つからない場合のcurlパス

  mkdir -p "$dest"
  local found
  # find DIR DIR ... CONDの手法だとARG_MAXを超えるからか失敗するケースが有る
  for dir in "${GIT_FILE_LOCATION[@]}"; do
    [[ -d "$dir" ]] || continue

    found=$(find "$dir" -type f -name "$target" -print -quit 2>/dev/null)
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

# Git Prompt

_HasGitPrompt()
{
  # 注意：シェル関数__git_ps1はinstall.shの世界では読み込まれない。
  # 一時的に対話シェルを立ち上げて確認する。
  # git-prompt.shはcompletion.dやprofile.dで読み込まれるためログインシェルでは不十分
  bash -l -i -c 'type __git_ps1 >/dev/null 2>&1'
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

# Git Diff Highlight

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

AppendIfNotExists() {
  local line="$1"
  local file="$2"
  grep -Fxq "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}
