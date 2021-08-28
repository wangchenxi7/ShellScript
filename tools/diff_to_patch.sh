#! /bin/bash

# 1) Put the old and new repo under the same directory 
# 2) Put the sh under the same directory of the repos
# 3) Strip the first level directory, e.g., Semeru and Semeru-dev when applying the path
#

## Configurations

#old_repo="OpenSourceCode/Semeru"
old_repo="Semeru"
new_repo="Semeru-new"

patch_tag="aug_27"

if [ -z "${HOME}" ]
then
  echo "Please set HOME"
  exit 
fi
home_dir=${HOME}
echo "home dir is ${home_dir}"


if [ -z "${old_repo}" ]
then
  echo "Input old_repo name. start from ${home_dir}:"
  read old_repo
fi
echo "The old repo: ${old_repo}"



if [ -z "${new_repo}" ]
then
  echo "Input new_repo name. start from ${home_dir}:"
  read new_repo
fi
echo "The new repo: ${new_repo}"


## patch related configs

patch_dir="${home_dir}/Patches"

if [ -e ${patch_dir} ]
then
  echo "Store the generated patch in ${patch_dir}"
else
  echo "generate patch dir ${patch_dir} and store the generated patch here"
  mkdir ${patch_dir}
fi


#diff --new-file  --exclude=".git" --exclude=".vscode-ctags"   -ru OpenSourceCode/Semeru   ./Semeru > semeru_nov_3.patch

echo "The diff dir start from ${old_repo}/ and ${new_repo}"
echo "So, stripped the first dir when applying the patch by patch -p1"
echo "diff --new-file  --exclude=".git" --exclude=".vscode-ctags"   -ru ${old_repo}  ${new_repo} > ${patch_dir}/semeru_${patch_tag}.patch"
diff --new-file  --exclude=".git" --exclude=".vscode-ctags"   -ru ${old_repo}  ${new_repo} > ${patch_dir}/semeru_${patch_tag}.patch
