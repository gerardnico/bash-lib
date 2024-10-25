# @name bashlib-bash documentation
# @brief Library for function over bash


# @description Print the function definition
bash::function_definition(){
  type "$1"
}


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