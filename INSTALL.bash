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

echo "Creating a path ..."
search_key="diff-highlight"
highlight=("$(find /usr -type f -name ${search_key} 2> /dev/null)")
if [ -z ${highlight[0]} ];then
  echo "Cannot find ${search_key}"
  exit 1
fi

ln -sv ${highlight[0]} /usr/local/bin
ln_result=$?

if [[ ${ln_result} == 1 ]]; then
  echo 'Cannot create a syambolic link'
  exit ${ln_result}
fi

echo '[include]' >> $HOME/.gitconfig
echo '    path = '$(abs_dirname "$0")'/option.sh' >> $HOME/.gitconfig
