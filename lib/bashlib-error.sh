# Library to handle error in bash
# How to use:
#
#   set -Ee                # Inherit trap for functions and stop at any error
#   source lib.error.sh    # Load the library
#   error::set_trap        # Set the error trap
#

# Depends on stack to print the callstack
source bashlib-stack.sh


# The error handling function
# that is called in the set_trap function
error::handler() {

    local ERROR_CODE=${1:-Unknown}
    local ERROR_COMMAND=${2:-Unknown}
    local ERROR_SOURCE=${3:-Unknown}
    local ERROR_FUNCTION=${4:-Unknown}
    local ERROR_LINE=${5:-Unknown}

    # Error in red
    echo -e "${RED:-'\033[0;31m'}"
    echo "Command '$ERROR_COMMAND' exited with status $ERROR_CODE"
    echo "  * File: $ERROR_SOURCE"
    echo "  * Function: $ERROR_FUNCTION"
    echo "  * Line: $ERROR_LINE"

    # We start at 2 and not 0 to not get:
    #  * the actual call to our own function handler::error
    #  * the actual call to the stack:print function
    echo "Error Call Stack:"
    stack::print 2

    # Rest color
    echo -e "${NC:-'\033[0m'}"

}

#
# Add the error handler via the creation of a error trap
#
# We advise to set the following bash configuration:
#
# set -E   # to apply the ERR trap to all shell functions
# set -e   # to exit if any error
#
# We use generally:
#
# set -Eeuo pipefail
#
# where the flag means:
# e - Exit if any error
# u - Treat unset variables as an error when substituting
# o pipefail - the return value of a pipeLOCATION is the status of the last command to exit with a non-zero status or zero if no command exited with a non-zero status
# E - the ERR trap is inherited by shell functions
error::set_trap() {
  trap 'error::handler "$?" "$BASH_COMMAND" "${BASH_SOURCE[0]}" "${FUNCNAME[0]}" $LINENO' ERR
}
