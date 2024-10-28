# @name bashlib-echo documentation
# @brief A echo library to log info, error and warning messages
# @description
#     With this library, you will be able to log info, error, debug and warning messages.
#
#     All messages are printed to `tty` (`stderr` if not available) to not pollute any pipe redirection.
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
#     They all accept the flag `--silent` or `-s` to no echo anything
#
# @see [bashlib](https://github.com/gerardnico/bash-lib)

# for the color
source bashlib-string.sh


# Message color
BASHLIB_ERROR_COLOR=${BASHLIB_ERROR_COLOR:-$BASHLIB_RED_COLOR}
BASHLIB_SUCCESS_COLOR=${BASHLIB_SUCCESS_COLOR:-$BASHLIB_GREEN_COLOR}
BASHLIB_WARNING_COLOR=${BASHLIB_WARNING_COLOR:-$BASHLIB_YELLOW_COLOR}
BASHLIB_TIP_COLOR=${BASHLIB_TIP_COLOR:-$BASHLIB_YELLOW_COLOR}

# Message level
export BASHLIB_ERROR_LEVEL=1
export BASHLIB_WARNING_LEVEL=2
export BASHLIB_INFO_LEVEL=3
export BASHLIB_DEBUG_LEVEL=4

# Formatting (Color, Prefix, ...)
BASHLIB_WARNING_TYPE="warning"
BASHLIB_SUCCESS_TYPE="success"
BASHLIB_ERROR_TYPE="error"
BASHLIB_DEBUG_TYPE="debug"
BASHLIB_ECHO_TYPE="echo"
BASHLIB_TIP_TYPE="tip"

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
  echo::base --log-level "$BASHLIB_INFO_LEVEL" "${*}"
}


# @description
#     Echo an error message in red by default.
#
#     You can choose the color by setting the `BASHLIB_ERROR_COLOR` env variable.
#
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    export BASHLIB_ERROR_COLOR='\033[0;31m' # Optional in Bashrc
#    echo::err "My Error"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::err() {
  echo::base --type "$BASHLIB_ERROR_TYPE" --log-level "$BASHLIB_ERROR_LEVEL" "${*}"
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
  echo::base --type "$BASHLIB_SUCCESS_TYPE" --log-level $BASHLIB_INFO_LEVEL "${*}"
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
  echo::base --type "$BASHLIB_WARNING_TYPE" --log-level "$BASHLIB_WARNING_LEVEL" "${*}"
}

# @description
#     Function to echo tip text
#
#     You can choose the color by setting the `BASHLIB_TIP_COLOR` env variable.
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    export BASHLIB_TIP_COLOR='\033[0;33m' # Optional in bashrc
#    echo::tip "My tip"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::tip() {
  echo::base --type "$BASHLIB_TIP_TYPE" --log-level "$BASHLIB_WARNING_LEVEL" "${*}"
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
  echo::base --log-level "$BASHLIB_DEBUG_LEVEL" --type "$BASHLIB_DEBUG_TYPE"  "${*}"
}

# @description
#     Function that will output the environment configuration
echo::conf(){
  echo::info "BASHLIB_LEVEL (Message Level): $BASHLIB_LEVEL"
}

# @description
#     Function to echo without prefix to stderr
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    echo::echo "My Debug statement"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
function echo::echo(){
  echo::base --log-level "$BASHLIB_INFO_LEVEL" --type "$BASHLIB_ECHO_TYPE"  "${*}"
}

# @internal
# @description
#    The base function that do the work
#    Should be at the end for the documentation generation
#    Accept as first argument a flag --silent or -s to no echo anything
# @arg $1 --silent -s - no echo
function echo::base(){

  local MESSAGE=""
  local TYPE_MESSAGE=""
  local LOG_LEVEL="$BASHLIB_INFO_LEVEL"
  while [[ $# -gt 0 ]]
  do
     case "$1" in
         "--silent"|"-s")
            return
           ;;
         "--type")
            shift
            TYPE_MESSAGE=$1
            shift
           ;;
         "--log-level")
             shift
             LOG_LEVEL=$1
             shift
            ;;
         "")
             # empty arg
             # It's the case if the silent flag is passed programmatically
             # ie echo::info $SILENT "Message"
             shift
            ;;
         *)
           MESSAGE=$1
           shift
     esac
  done

  # Level
  if [ "$BASHLIB_LEVEL" -lt "$LOG_LEVEL" ]; then
    return
  fi

  # Type Prefix
  case $TYPE_MESSAGE in
    "$BASHLIB_SUCCESS_TYPE")
      MESSAGE="Success: $MESSAGE"
      ;;
    "$BASHLIB_ERROR_TYPE")
      MESSAGE="Error: $MESSAGE"
      ;;
    "$BASHLIB_WARNING_TYPE")
      MESSAGE="Warning: $MESSAGE"
      ;;
    "$BASHLIB_DEBUG_TYPE")
      MESSAGE="Debug: $MESSAGE"
      ;;
    "$BASHLIB_TIP_TYPE")
      MESSAGE="Tip: $MESSAGE"
      ;;
  esac

  # Color
  case $TYPE_MESSAGE in
    "$BASHLIB_SUCCESS_TYPE")
      MESSAGE="${BASHLIB_SUCCESS_COLOR}${MESSAGE}${NC}"
      ;;
    "$BASHLIB_ERROR_TYPE")
      MESSAGE="${BASHLIB_ERROR_COLOR}${MESSAGE}${NC}"
      ;;
    "$BASHLIB_WARNING_TYPE")
      MESSAGE="${BASHLIB_WARNING_COLOR}${MESSAGE}${NC}"
      ;;
    "$BASHLIB_TIP_TYPE")
      MESSAGE="${BASHLIB_TIP_COLOR}${MESSAGE}${NC}"
      ;;
  esac

  # Location Information
  case $TYPE_MESSAGE in
    "$BASHLIB_ECHO_TYPE")
      # echo does not have location information
      ;;
    *)
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
      MESSAGE="$CALLING_SCRIPT::$CALLING_FUNCTION#$LINE: ${MESSAGE}"
      ;;
  esac

  # do we have a terminal
  # the -c option checks if the file is a character device
  if test -c /dev/tty; then
    # To /dev/tty
    # No access if you're running the script in a non-interactive environment
    echo -e "${MESSAGE}" > /dev/tty
    return
  fi

  # stderr may not be available
  if test -c /dev/stderr; then
    # To stderr
    echo -e "${MESSAGE}" >&2
    return
  fi

  # stdout may not be available
  # This is the case when a command is executed from another command directly (not via shell)
  # Example when `git` calls `ssh`, no stdout is attached
  if test -c /dev/stdout; then
    # To stdout
    echo -e "${MESSAGE}"
    return
  fi

  echo "Not device available for the message ${MESSAGE}"
  return 1


}
