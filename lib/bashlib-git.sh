# @name bashlib-git documentation
# @brief Library of Git wrapper functions (known wildly as git helpers)
# @description
#
#     See also [git-extras](https://github.com/tj/git-extras/blob/main/Commands.md)


# shellcheck source=./bashlib-echo.sh
source "bashlib-echo.sh"
# shellcheck source=./bashlib-command.sh
source "bashlib-command.sh"

# @description Get the default branch
git::get_default_branch() {
  # shellcheck disable=SC2317
  # git remote show origin | grep "HEAD branch" | sed 's/.*: //'
  git symbolic-ref refs/remotes/origin/HEAD --short | sed 's/origin\///'
}

# @description Get the current branch
git::get_current_branch() {
  # Command with HEAD does not work if there is no commit yet
  # Does not work:
  #   git symbolic-ref HEAD --short
  #   git rev-parse --abbrev-ref HEAD
  git branch --show-current
}

# @description Get the current upstream branch
# @exitcode 0 - always
# @stdout - the name of the upstream or the empty string
git::get_current_upstream_branch() {
  # git-rev parse will fail if there is no upstream
  if UPSTREAM=$(git rev-parse --abbrev-ref "@{u}"); then
    echo "$UPSTREAM"
    exit 0
  fi
  echo ""
}

# @description Go to the default branch (main/master)
# @example
#   git::checkout_main
function git::checkout_default() {
  git checkout "$(git::get_default_branch)"
  git pull
}

# @description Diff of one file with the head
# @args $1 - the file to diff
# @example
#   gdiff README.md
git::diff() {
  git diff HEAD "$1" | $EDITOR
}

# @description
#    Check if there is some modified or delete files not commited
# @exitcode 1 if the repo is index dirty
git::is_dirty_index() {
  # Any files modified
  ! git diff-index --quiet HEAD --
}

# @description
#    Check if a branch exists
# @args $1 - the branch name
# @exitcode 1 if the branch does not exists
git::branch_exists() {
  git show-ref --verify --quiet "refs/heads/$1"
}

# @description
#    Check if there is some commit not pushed
# @exitcode 1 if their is some commit not pushed
git::is_dirty_commit() {
  COMMIT_NOT_PUSHED=$(git::get_commits_not_pushed)
  [ "$COMMIT_NOT_PUSHED" != "0" ]
}

# @description
#    Check if there is:
#      * some modified or delete files not commited
#      * some commit not pushed
# @exitcode 0 if the repo is dirty
# @exitcode 1 if the repo is not dirty
git::is_dirty() {
  if git::is_dirty_commit; then
    return 0
  fi
  git::is_dirty_index
}

# @description
#    Get the commits not integrated from remote
# @stdout the commits not integrated
git::get_commits_upstream_behind() {
  # same as `git rev-list '@{u}'...HEAD --count`
  git 'rev-list' '--count' '@{u}..@{0}'
}

# @description
#    Get the commits not integrated in the upstream branch
#    The repository is considered dirty if this the case
# @stdout the commits not pushed
git::get_commits_not_pushed() {
  # same as `git rev-list '@{u}'...HEAD --count`
  git 'rev-list' '--count' '@{u}..@{0}'
}

# @description Create a full git string command
git::get_eval_string() {
  local ARGS=()
  ARGS+=("git")
  # extract the command
  GIT_COMMAND=$1
  shift

  # Config Color output ?
  if [[ "$GIT_COMMAND" != "wanabi" ]]; then
    # https://git-scm.com/book/sv/v2/Customizing-Git-Git-Configuration#_colors_in_git
    ARGS+=("-c")
    ARGS+=("color.ui=always")
  fi

  # Command after config
  ARGS+=("$GIT_COMMAND")

  # Escape to avoid error such as
  local ESCAPED_ARG
  for ARG in "${@}"; do
    ESCAPED_ARG="$(command::escape "$ARG")"
    ARGS+=("$ESCAPED_ARG")
  done
  echo "${ARGS[@]}"
}

# @return a list of dirty files
# @arg $1 string - the separator (by default a comma)
git::get_dirty_files() {

  SEP=${1:-$', '}
  local DIRTY_FILES=()
  for path in $(git diff-index --name-only HEAD); do
    DIRTY_FILES+=(" ${path##*/}")
  done
  IFS="$SEP" echo "${DIRTY_FILES[*]}"

}

# @description returns the root directory
git::get_root_directory() {
  git rev-parse --show-toplevel
}

# @description create a commit message automatically based on the changed files
git::get_auto_commit_message() {

  message="feat: backup $(git::get_dirty_files $', ')"
  echo "${message:0:50}"

}

# @description Check if the branch has an upstream
# @args $1 string a branch
git::has_upstream() {
  git show-branch remotes/origin/$1 &> /dev/null
}

# Example
# https://github.com/jouve/charts/blob/main/git-subtree-pull.sh
git::subtree_pull() {
  src_url=$1
  src_tag=$2
  src_dir=$3
  tgt_dir=$4
  tmp=$(mktemp -d)
  git clone "$src_url" "$tmp"
  ref=$(git -C "$tmp" subtree split "--prefix=$src_dir" "$src_tag")
  git subtree pull "--prefix=$tgt_dir" "$tmp" "$ref"
}
