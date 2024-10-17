# @name bashlib-git documentation
# @brief Library of Git wrapper functions
# @description
#     You would insert them in your `.bashrc` with `source bashlib-git.sh`
#
#     See also [git-extras](https://github.com/tj/git-extras/blob/main/Commands.md)

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

  # `--renormalize` to correct the EOL in the working tree
  # renormalize does not add any file into the index
  # we need to add it twice
  git add --renormalize . && git add . && git commit -m "$1" && git push

}

# @description Diff with the head
# @args $1 - the file to diff
# @example
#   gdiff README.md
gdiff(){
  git diff HEAD $1
}


# alias in the wild
# gst - for `git status`
# gc — for `git commit`
# co — for `git checkout`
# gaa — for `git add -A`
# gd — for `git diff`
# gdc — for `git diff —cached`
# 
# check change would be
# gst gd gaa gst gdc gc 
# 
# alias: https://github.com/mrnugget/dotfiles/blob/c4624ed521d539856bcf764f04a295bb19093566/gitconfig

# https://github.com/mrnugget/dotfiles/blob/c4624ed521d539856bcf764f04a295bb19093566/githelpers#L11-L15
