#! /bin/bash

## Configurations

old_repo="Semeru"
new_repo="Semeru-new"

if [ -z "${HOME}" ]
then
  echo "Please set HOME"
  exit 
fi
home_dir=${HOME}
echo "home dir is ${home_dir}"


if [ -z "${old_repo}" ]
  echo "Input old_repo name. start from ${home_dir}:"
  read old_repo
fi
echo "The old repo: ${old_repo}"


if [ -z "${new_repo}" ]
  echo "Input new_repo name. start from ${home_dir}:"
  read new_repo
fi
echo "The new repo: ${new_repo}"




#diff --new-file  --exclude=".git" --exclude=".vscode-ctags"   -ru OpenSourceCode/Semeru   ./Semeru > semeru_nov_3.patch
diff --new-file  --exclude=".git" --exclude=".vscode-ctags"   -ru ${home_dir}/${old_repo}   ${home_dir}/${new_repo} > semeru_aug_27.patch
