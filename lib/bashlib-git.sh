# @name bashlib-git documentation
# @brief Library of Git wrapper functions
# @description
#     You would insert them in your `.bashrc` with `source bashlib-git.sh`
#

# @description An alias function for `git status`
# @example
#   gs
gs(){
  git status
}

# @description An alias function for `Git Add Commit and Push`
# @args $1 - the commit message
# @example
#   ga "My Commit Message"
ga(){
  git add . && git commit -m "$1" && git push
}

# @description Normalize all file to a new line ending
# @example
#   git-normalize-text
#   gs # to see the change file
#   ga "New line ending"
git-eol(){
  git add --renormalize .
}
