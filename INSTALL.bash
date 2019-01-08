#!/bin/bash

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


if ! type git &> /dev/null; then
  echo "Git is not installed"
fi

ln -sv /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin

if [[ $? == 1 ]]; then
  echo 'Cannot create a syambolic link'
  exit $?
fi

echo '[include]' >> $HOME/.gitconfig
echo '    path = '$(abs_dirname "$0")'/option.sh' >> $HOME/.gitconfig
