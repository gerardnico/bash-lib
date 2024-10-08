# @name bashlib-echo documentation
# @brief A echo library to log info, error and warning messages
# @description
#     With this library, you will be able to log info, error, debug and warning messages.
#
#     All messages are printed to `stderr` to not pollute any pipe redirection.
#
#     You can also define the message printed by setting the level via the `BASHLIB_LEVEL` environment
#     Setting it to:
#     * `0`: disable all messages
#     * `1`: print error messages
#     * `2`: print also warning messages
#     * `3`: print also info and success messages
#     * `4`: print also debug messages
#     By default, the library has the level `3` (info messages and up)
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

# Message level
BASHLIB_ERROR_LEVEL=1
BASHLIB_WARNING_LEVEL=2
BASHLIB_INFO_LEVEL=3
BASHLIB_DEBUG_LEVEL=4

# The actual level
BASHLIB_LEVEL=${BASHLIB_LEVEL:-$BASHLIB_INFO_LEVEL}


# @description Echo an info message
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    # Default terminal color
#    echo::info "My Info"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
function echo::info() {
  echo::base "$1"
}




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
  if [ "$BASHLIB_LEVEL" -ge "$BASHLIB_ERROR_LEVEL"  ]; then
    echo::base "${BASHLIB_ERROR_COLOR}Error: $1${NC}"
  fi
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
  if [ "$BASHLIB_LEVEL" -ge "$BASHLIB_INFO_LEVEL" ]; then
      echo::base "${BASHLIB_SUCCESS_COLOR}Success: $1${NC}"
  fi
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
  if [ "$BASHLIB_LEVEL" -ge "$BASHLIB_WARNING_LEVEL" ]; then
    echo::base -e "${BASHLIB_WARNING_COLOR}Warning: $1${NC}"
  fi
}

# @description
#     Function to echo debug text
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    echo::debug "My Debug statement"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::debug() {
    if [ "$BASHLIB_LEVEL" -ge "$BASHLIB_DEBUG_LEVEL" ]; then
      echo::base "Debug: $1"
    fi
}

# @description
#     Function that will output the environment configuration
echo::conf(){
  echo::info "BASHLIB_LEVEL (Message Level): $BASHLIB_LEVEL"
}


# @internal
# The base function that do the work
# Should be at the end for the documentation generation
function echo::base(){

  # The caller function displays:
  # * the line number,
  # * subroutine name,
  # * and source file corresponding
  #
  # `caller 0` returns the actual calling executing function
  # Because this is a base function that call all echo function we want the `caller 1`
  #
  # See https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-caller
  read -r LINE CALLING_FUNCTION CALLING_SCRIPT <<< "$(caller 1)"
  CALLING_SCRIPT=$(basename "$CALLING_SCRIPT")

  # We send all echo to the error stream
  # so that any redirection will not get them
  # this is the standard behaviour of git
  echo -e "$CALLING_SCRIPT::$CALLING_FUNCTION#$LINE: ${1:-}" >&2

}

