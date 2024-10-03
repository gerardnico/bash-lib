#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/echo.sh"
source "$SCRIPT_DIR/stack.sh"

# Define the error handling function
error_handler() {

    local err=$?
    local line=$1
    local command="$2"
    echo_err ""
    echo_err "Command '$command' exited with status $err."
    echo_err ""
    SCRIPT=${BASH_SOURCE[1]}
    if [ "$SCRIPT" == "" ]; then
      # Line is completely off in this case
      echo_err "Error on the main script."
      echo_err "Possible causes: (as no location was given for the error by Bash)"
      echo_err "   The command was not found"
      echo_err "   The command is a bash builtin-command (shift, ...)"
      echo_err "   The 'source' key word was forgotten "
      return
    fi
    echo_err "Error on $SCRIPT line $line"

    echo_err ""
    print_stack

}


## A trap on ERR, if set, is executed before the shell exits.
# Because we show the $LINENO, we need to pass a command to the trap and not a function otherwise the line number would be not correct
# trap 'error_handler "$LINENO" "${BASH_COMMAND}"' ERR

## A simple trap to copy on external file
# trap 'echo_err ""; echo_err "Command error on line ($0:$LINENO)";' ERR
# trap 'echo ""; echo "Command error on line ($0:$LINENO)";' ERR