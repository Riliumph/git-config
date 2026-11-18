################################################################################
# URLs
################################################################################

GIT_PROMPT_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"

GIT_COMPLETION_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"

DIFF_HIGHLIGHT_URL="https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight"

################################################################################
# Candidate Paths
################################################################################

# `$ grep -R "git-sh-prompt" /etc/profile /etc/bash.bashrc /etc/profile.d /etc/bash_completion.d 2>/dev/null`
GIT_PROMPT_CANDIDATES=(
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
GIT_COMPLETION_CANDIDATES=(
  ## Linux
  # load in /etc/bash.bashrc
  "/usr/share/bash-completion/completions/git"
  "/usr/share/git/completion/git-completion.bash"
  ## macOS
)

DIFF_HIGHLIGHT_CANDIDATES=(
  "/usr/share/doc/git/contrib/diff-highlight/diff-highlight"
)

################################################################################
# Functions
################################################################################

AppendIfNotExists()
{
  local line="$1"
  local file="$2"

  grep -Fxq "$line" "$file" 2> /dev/null \
    || echo "$line" >> "$file"
}

InstallGitHelper()
{
  local dest="$1"
  local url="$2"

  shift 2

  local src

  for src in "$@"; do
    [[ -r "$src" ]] || continue

    info "copy $src -> $dest"
    cp -f "$src" "$dest"

    return 0
  done

  info "download $(basename "$dest")"
  curl -fsSL "$url" -o "$dest"
}

################################################################################
# diff-highlight
################################################################################

InstallDiffHighlight()
{
  local dest="$1"
  local url="$2"

  shift 2

  local src

  for src in "$@"; do
    [[ -r "$src" ]] || continue

    info "copy $src -> $dest"
    cp -f "$src" "$dest"

    return 0
  done

  # make
  for exe in "$@"; do
    parent_dir="${exe%/*}"
    makefile_path="${parent_dir}/Makefile"

    if [[ -f "$makefile_path" ]]; then
      build_dir="/tmp/${parent_dir##*/}"
      cp -rf "$parent_dir" "$build_dir"
      make -C "$build_dir" || continue
      cp -f "$build_dir/diff-highlight" "$dest"
      return 0
    fi
  done
}
