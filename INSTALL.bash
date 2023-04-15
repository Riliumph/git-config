#!/bin/bash

###
# Convert to absolute path
# @param $1 path
# @return absolute path
abs_dirname() {
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
if ! type git &>/dev/null; then
  echo "Git is not installed"
  exit 1
fi

echo "Setting diff-highlight ..."
if [ -e "${user_bin}/diff-highlight" ]; then
  echo "  Skipped as the file already exists"
else
  echo "  Searching diff-highlight ..."
  search_key="diff-highlight"
  highlight=("$(find /usr -type f -name ${search_key} 2>/dev/null)")
  if [ -z "${highlight[0]}" ]; then
    echo "  Cannot find ${search_key}"
    exit 1
  fi

  echo "  Linking diff-highliht ..."
  mkdir -p "$HOME/bin"
  ln -sv "${highlight[0]}" "${user_bin}"
  ln_result=$?
  if [[ ${ln_result} == 1 ]]; then
    echo 'Cannot create a syambolic link'
    exit ${ln_result}
  fi
fi

echo "Setting bash ..."
echo 'export PATH="$HOME/bin:${PATH}"' >>"$HOME/.bashrc"
echo '[include]
    path = '$(abs_dirname "$0")'/option.sh' >>"$HOME/.gitconfig"
echo "DONE!!"
