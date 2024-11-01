# @name bashlib-bash documentation
# @brief Library for function over bash

source bashlib-echo.sh



# @description
#   This command overrides the default trap function
#   and add the ability to set multiple traps for the same signal
#
# @args $1 string the code expression
# @args $2-N names of signals
#
bash::trap() {
  # You can't set multiple traps for the same signal, but you
  # can add to an existing trap:
  # We:
  # 1. Fetch the existing trap code using `trap -p`
  # 2. Add the command, separated by a semicolon or newline
  # 3. Set the trap to the result of 2

  TRAP_EXPRESSION=$1;
  shift
  for TRAP_SIGNAL in "$@"; do
    # shellcheck disable=SC2016
    PREVIOUS_TRAP_COMMAND=$(trap -p "${TRAP_SIGNAL}" | xargs bash -c 'echo $2')
    COMMAND=$(printf '%s\n%s' "$PREVIOUS_TRAP_COMMAND" "${TRAP_EXPRESSION}")
    trap -- "$COMMAND" "${TRAP_SIGNAL}"
  done
}

# @description check to see if a shell is interactive
# @exitcode 0 If the shell is interactive
# @exitcode 1 If the shell is non-interactive
function bash::is_interactive(){
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
function bash::is_login(){
  if shopt -q login_shell; then
      echo::debug "The shell is a login shell."
      return 0
  fi
  echo::debug "The shell is not a login shell."
  return 1
}

# @description
#    Print the state/conf of the shell
#    * Is it an interactive shell or not
#    * Is it a login shell or not
#
function bash::conf(){

  echo "Interactive : $(if shell::is_interactive; then echo "Yes"; else echo "No"; fi)"
  echo "Login       : $(if shell::is_login; then echo "Yes"; else echo "No"; fi)"
  echo "BASH_ENV    : $BASH_ENV"

}

# @description Print the function definition
bash::function_definition(){
  type "$1"
}

# @description Check if the script has a terminal
bash::has_terminal(){
  tty -s
}