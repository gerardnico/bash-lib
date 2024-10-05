# Git Library



# Alias and function
alias gs='git status'


# Git Auto-push
ga(){
  git add . && git commit -m "$1" && git push
}