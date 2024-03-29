#!/bin/bash

###
# Convert to absolute path
# @param $1 path
# @return absolute path
abs_dirname()
{
  local path="$1"

  # Check path existence one by one
  while [ -n "$path" ]; do
    cd "${path%/*}" || { # Remove the shortest pattern(/*) from right
      echo "fail to make prompt"
      exit
    }
    local name="${path##*/}" # Remove the longest pattern(*/) from left
    path="$(readlink "$name" || true)"
  done

  pwd -P # return string
}

user_bin="$HOME/bin"

echo "Checking git ..."
if ! type git &> /dev/null; then
  echo "Git is not installed"
  exit 1
fi

echo "Setting diff-highlight ..."
if ! type diff-highlight &> /dev/null; then
  echo "  Searching diff-highlight ..."
  search_key="diff-highlight"
  mapfile highlight < <(find /usr/share -type f -name "${search_key}")
  if [ -z "${highlight[0]}" ]; then
    mapfile highlight < <(find /usr/share -type d -name "${search_key}")
    if [ -z "${highlight[0]}" ]; then
      cd "${highlight[0]}" || exit 1
      make || exit 1
      highlight[0]="${highlight}/diff-highlight"
    fi
  fi

  echo "  Linking diff-highliht ..."
  mkdir -p "${user_bin}"
  if ! ln -sfv "${highlight[0]}" "${user_bin}"; then
    echo 'Cannot create a syambolic link'
    exit 1
  fi
fi

echo "Setting bash ..."
echo 'export PATH="$HOME/bin:${PATH}"' >> "$HOME/.bashrc"
echo "Install git config"
if [ -z "${XDG_CONFIG_HOME}" ]; then
  export XDG_CONFIG_HOME="${HOME}/.config"
fi
mkdir -p "${XDG_CONFIG_HOME}/git"
ln -sfv "$(abs_dirname "$0")/option.conf" "$XDG_CONFIG_HOME/git/config"
echo "DONE!!"
