# @name bashlib-git documentation
# @brief Library of Git wrapper functions (known wildly as git helpers)
# @description
#
#     See also [git-extras](https://github.com/tj/git-extras/blob/main/Commands.md)

source bashlib-echo.sh

# @description Get the default branch
git::get_default_branch(){
  # shellcheck disable=SC2317
  git remote show origin | grep "HEAD branch" | sed 's/.*: //'
}

# @description Get the current branch
git::get_current_branch(){
  # works also: git symbolic-ref HEAD --short
  git rev-parse --abbrev-ref HEAD
}

# @description Get the current upstream branch
git::get_current_upstream_branch(){
  git rev-parse --abbrev-ref "@{u}"
}



# @description Go to the default branch (main/master)
# @example
#   git::checkout_main
function git::checkout_default() {
  git checkout "$(git::get_default_branch)"
  git pull
}

# @description Delete the current branch and go to the default branch
function git::branch_delete() {
  CURRENT_BRANCH=$(git::get_current_branch)
  git checkout "$(git::get_default_branch)"
  # delete
  git branch -D "$CURRENT_BRANCH"
  git pull
}

# @description Diff of one file with the head
# @args $1 - the file to diff
# @example
#   gdiff README.md
git::diff(){
  git diff HEAD "$1" | $EDITOR
}
