#! /bin/bash

## Configurations

old_repo=$1
new_repo=$2

if [ -z "${old_repo}" ]
  echo "Input old_repo"
  read old_repo
fi
echo "The old repo: ${old_repo}"




diff --new-file  --exclude=".git" --exclude=".vscode-ctags"   -ru OpenSourceCode/Semeru   ./Semeru > semeru_nov_3.patch
