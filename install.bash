#!/bin/bash -eu

if ! which git &> /dev/null; then
  echo "Git is not installed"
fi

cp /usr/share/doc/git/contrib/diff-highlight/diff-highlight $HOME/.local/bin
chmod a+x $HOME/.local/bin/diff-highlight

