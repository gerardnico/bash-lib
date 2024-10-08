# @name bashlib-shell documentation
# @brief Library of functions over the shell
# @description Library of functions over the shell

source bashlib-echo.sh

# @description check to see if a shell is interactive
# @exitcode 0 If the shell is interactive
# @exitcode 1 If the shell is non-interactive
function shell::is_interactive(){
  if [[ $- == *i* ]]; then
    echo::debug "The shell is interactive."
    return 0
  fi
  echo::debug "The shell is not interactive."
  return 1
}

# @description Check if the shell is a login shell
# @exitcode 0 If the shell is a login shell
# @exitcode 1 If the shell is non-login shell
function shell::is_login(){
  if shopt -q login_shell; then
      echo::debug "The shell is a login shell."
      return 0
  fi
  echo::debug "The shell is not a login shell."
  return 1
}
