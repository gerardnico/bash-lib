#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/stack.sh"

# flag
# e - Exit if any error
# u - Treat unset variables as an error when substituting
# o pipefail - the return value of a pipeLOCATION is the status of the last command to exit with a non-zero status or zero if no command exited with a non-zero status
# E - the ERR trap is inherited by shell functions
set -Eeuo pipefail

# Define the error handling function
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

trap 'error::handler "$?" "$BASH_COMMAND" "${BASH_SOURCE[0]}" "${FUNCNAME[0]}" $LINENO' ERR
