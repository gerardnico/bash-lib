# @name bashlib-error documentation
# @brief Library to handle error in bash
# @description
#     With this library, you will be able to add an error handler
#     See the function [set_trap](#errorset_trap) for a usage example
#
#
#
# Depends on stack to print the callstack
source bashlib-stack.sh


# @description
#    An error handling function that will print:
#    * The command in error
#    * The exit status
#    * And error location information
#       * The source file
#       * The function
#       * The line
#    This function is called by the error:set_trap
# @arg $1 - the error code
# @arg $2 - the command
# @arg $2 - the file source
# @arg $3 - the function name
# @arg $4 - the line number
# @exitcode 0 Always
# @example
#    # used in the error:set_trap function
#    error::handler "$?" "$BASH_COMMAND" "${BASH_SOURCE[0]}" "${FUNCNAME[0]}" $LINENO
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
#
error::handler() {

    local ERROR_CODE=${1:-Unknown}
    local ERROR_COMMAND=${2:-Unknown}
    local ERROR_SOURCE=${3:-Unknown}
    local ERROR_FUNCTION=${4:-'Not in a function'}
    local ERROR_LINE=${5:-Unknown}

    # Error in red
    echo -e "${RED:-'\033[0;31m'}" >&2
    echo "Command '$ERROR_COMMAND' exited with status $ERROR_CODE" >&2
    echo "  * File: $ERROR_SOURCE" >&2
    echo "  * Function: $ERROR_FUNCTION" >&2
    echo "  * Line: $ERROR_LINE" >&2

    # We start at 2 and not 0 to not get:
    #  * the actual call to our own function handler::error
    #  * the actual call to the stack:print function
    echo "Error Call Stack:" >&2
    stack::print 3 >&2

    # Rest color
    echo -e "${NC:-'\033[0m'}" >&2

}

# @description
#    Add the error handler via the creation of a error trap
#    In your script, we advise to set the error option. See example.
#
# @example
#    set -Eeuo pipefail # A onliner
#    # where the flag means:
#    #   e - Exit if any error
#    #   u - Treat unset variables as an error when substituting
#    #   o pipefail - the return value of a pipeLOCATION is the status of the last command to exit with a non-zero status or zero if no command exited with a non-zero status
#    #   E - the ERR trap is inherited by shell functions
#    source bashlib-error.sh # Import the library
#    error:set_trap
#
# @noarg
# @set trap for error
error::set_trap() {
  # Note: function may be null
  trap 'error::handler "$?" "$BASH_COMMAND" "${BASH_SOURCE[0]}" "${FUNCNAME[0]:-}" $LINENO' ERR
}

# @description
#    Exit properly by deleting any ERR trap
#    even if the exit code is not 0
# @args $1 - the exit code
error::exit(){

  trap - ERR
  exit "$1"

}
