# @name bashlib-echo documentation
# @brief A echo library to log info, error and warning message
# @description
#     With this library, you will be able to log info, error and warning message.
#
# @see [bashlib](https://github.com/gerardnico/bash-lib)

# ANSI color codes
RED=${RED:-'\033[0;31m'}
GREEN=${GREEN:-'\033[0;32m'}
YELLOW=${YELLOW:-'\033[0;33m'}
NC='\033[0m' # No Color


# Message color
BASHLIB_ERROR_COLOR=${BASHLIB_ERROR_COLOR:-$RED}
BASHLIB_SUCCESS_COLOR=${BASHLIB_SUCCESS_COLOR:-$GREEN}
BASHLIB_WARNING_COLOR=${BASHLIB_WARNING_COLOR:-$YELLOW}


# @description Echo an info message
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    # Default terminal color
#    echo::info "My Info"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
function echo::info() {

  # The caller function displays:
  # * the line number,
  # * subroutine name,
  # * and source file corresponding
  #
  # `caller 0` returns the actual calling executing function
  #
  # See https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-caller
  read -r LINE CALLING_FUNCTION CALLING_SCRIPT <<< "$(caller 0)"
  CALLING_SCRIPT=$(basename "$CALLING_SCRIPT")

  # We send all echo to the error stream
  # so that any redirection will not get them
  # this is the standard behaviour of git
  echo -e "$CALLING_SCRIPT::$CALLING_FUNCTION#$LINE: ${1:-}" >&2

}

#
# @description
#     Echo an error message in red by default.
#
#     You can choose the color by setting the `BASHLIB_ERROR_COLOR` env variable.
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    export BASHLIB_ERROR_COLOR='\033[0;31m' # Optional in Bashrc
#    echo::err "My Error"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::err() {
  echo::info "${BASHLIB_ERROR_COLOR}Error: $1${NC}"
}

# @description
#     Echo an success message in green
#
#     You can choose the color by setting the `BASHLIB_SUCCESS_COLOR` env variable.
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    export BASHLIB_SUCCESS_COLOR='\033[0;32m' # Optional in bashrc
#    echo::success "My Info"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::success() {
    echo::info -e "${BASHLIB_SUCCESS_COLOR}Success: $1${NC}"
}

# @description
#     Function to echo text in yellow (for warnings)
#
#     You can choose the color by setting the `BASHLIB_WARNING_COLOR` env variable.
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    export BASHLIB_WARNING_COLOR='\033[0;33m' # Optional in bashrc
#    echo::warn "My Warning"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::warn() {
    echo::info -e "${BASHLIB_WARNING_COLOR}Warning: $1${NC}"
}

