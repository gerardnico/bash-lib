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