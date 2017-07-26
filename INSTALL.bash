#!/bin/bash -eu


###
# Convert to absolute path
# @param $1 path
# @return absolute path
abs_dirname() {
  local path="$1"

  # Check path existence one by one
  while [ -n "$path" ]; do
    cd "${path%/*}"  # Remove the shortest pattern(/*) from right
    local name="${path##*/}"  # Remove the longest pattern(*/) from left
    path="$(readlink "$name" || true)"
  done

  pwd -P  # return string
}


if ! which git &> /dev/null; then
  echo "Git is not installed"
fi

cp /usr/share/doc/git/contrib/diff-highlight/diff-highlight /usr/local/bin/
chmod a+x /usr/local/bin/diff-highlight

echo '[include]' >> $HOME/.gitconfig
echo '    path = '$(abs_dirname "$0")'/option.sh' >> $HOME/.gitconfig
