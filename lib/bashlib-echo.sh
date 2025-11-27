# @name bashlib-echo documentation
# @brief A echo library to log info, error and warning messages
# @description
#     With this library, you will be able to log info, error, debug and warning messages.
#
#     All messages are printed to `tty` (`stderr` if not available) to not pollute any pipe redirection.
#
#     You can also define the message printed by setting the level via the `BASHLIB_ECHO_LEVEL` environment
#     Setting it to:
#     * `0`: disable all messages
#     * `1`: print error messages
#     * `2`: print also warning messages
#     * `3`: print also info and success messages
#     * `4`: print also command messages
#     * `5`: print also debug messages
#     By default, the library has the level `3` (info messages and up)
#
#     They all accept the flag `--silent` or `-s` to no echo anything
#
# @see [bashlib](https://github.com/gerardnico/bash-lib)

# for the color
# shellcheck source=./bashlib-string.sh
source "bashlib-string.sh"

# Message color
BASHLIB_ERROR_COLOR=${BASHLIB_ERROR_COLOR:-$BASHLIB_RED_COLOR}
BASHLIB_SUCCESS_COLOR=${BASHLIB_SUCCESS_COLOR:-$BASHLIB_GREEN_COLOR}
BASHLIB_WARNING_COLOR=${BASHLIB_WARNING_COLOR:-$BASHLIB_YELLOW_COLOR}
BASHLIB_TIP_COLOR=${BASHLIB_TIP_COLOR:-$BASHLIB_YELLOW_COLOR}

# Message level
export BASHLIB_ECHO_ERROR_LEVEL=1
export BASHLIB_ECHO_WARNING_LEVEL=2
export BASHLIB_ECHO_INFO_LEVEL=3
export BASHLIB_ECHO_COMMAND_LEVEL=4
export BASHLIB_ECHO_DEBUG_LEVEL=5

# Formatting (Color, Prefix, ...)
BASHLIB_WARNING_TYPE="warning"
BASHLIB_COMMAND_TYPE="command"
BASHLIB_SUCCESS_TYPE="success"
BASHLIB_ERROR_TYPE="error"
BASHLIB_DEBUG_TYPE="debug"
BASHLIB_ECHO_TYPE="echo"
BASHLIB_TIP_TYPE="tip"

# The actual level
BASHLIB_ECHO_LEVEL=${BASHLIB_ECHO_LEVEL:-$BASHLIB_ECHO_INFO_LEVEL}

# @description Echo an info message
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    # Default terminal color
#    echo::info "My Info"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
function echo::info() {
  echo::base --log-level "$BASHLIB_ECHO_INFO_LEVEL" "${*}"
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
  echo::base --type "$BASHLIB_ERROR_TYPE" --log-level "$BASHLIB_ECHO_ERROR_LEVEL" "${*}"
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
  echo::base --type "$BASHLIB_SUCCESS_TYPE" --log-level $BASHLIB_ECHO_INFO_LEVEL "${*}"
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
  echo::base --type "$BASHLIB_WARNING_TYPE" --log-level "$BASHLIB_ECHO_WARNING_LEVEL" "${*}"
}

# @description
#     Function to echo tip text
#
#     You can choose the color by setting the `BASHLIB_TIP_COLOR` env variable.
#
# @arg $1 string The value to print, by default an empty line
# @exitcode 0 Always
# @example
#    export BASHLIB_TIP_COLOR='\033[0;33m'
#    echo::tip "My tip"
#
# @stderr The output is always in stderr to avoid polluting stdout with log message (git ways)
echo::tip() {
  echo::base --type "$BASHLIB_TIP_TYPE" --log-level "$BASHLIB_ECHO_WARNING_LEVEL" "${*}"
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
  echo::base --log-level "$BASHLIB_ECHO_DEBUG_LEVEL" --type "$BASHLIB_DEBUG_TYPE" "${*}"
}

# @description
#     Function that will output the environment configuration
echo::conf() {
  echo::info "BASHLIB_ECHO_LEVEL (Message Level): $BASHLIB_ECHO_LEVEL"
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
function echo::echo() {
  echo::base --log-level "$BASHLIB_ECHO_INFO_LEVEL" --type "$BASHLIB_ECHO_TYPE" "${*}"
}

# @description
#     Function to eval and echo a command
#
# @arg $1 string The command
# @arg $2 string The file descriptor where to redirect stderr
# @exitcode 0 The exit code of the eval function
# @example
#    echo::eval "echo 'Hello World'"
#
# @stdout The output of the command
function echo::eval() {
  # redirect eventually stderr to /dev/tty
  # Why? stderr may be captured by the called command and we don't see any error
  local STDERR_FD=${2:-$(echo::get_file_descriptor)}
  local FINAL_COMMAND="$1 2>$STDERR_FD"
  echo::base --log-level "$BASHLIB_ECHO_COMMAND_LEVEL" --type "$BASHLIB_COMMAND_TYPE" "$FINAL_COMMAND"
  eval "$FINAL_COMMAND"
}

# @description
#     Return the file descriptor to be used for the echo messages
#
#     Note: The echo library does not return anything on stdout
#     Why?
#     * stdout is the file descriptor used in processing (pipelining, ....)
#     * command such as the below would not stop. They would just process `stdout` of the command and of the trap if any
#     ```bash
#     for var in $(command_with_echo_error)
#     ```
#
# @exitcode 0 always
# @example
#    FD=$(echo::get_file_descriptor)
#    echo "Hallo World" > "$FD"
#
# @stdout A file descriptor (default to /dev/stderr)
function echo::get_file_descriptor() {

  # interactive textual terminal session ?
  #
  # do we have a terminal alias
  # the -c option [ -c /dev/tty ] checks if the file is a character device
  # does not work, still true and we get /dev/tty: No such device or address
  # -t FD  file descriptor FD is opened on a terminal
  # /dev/tty is the controlling terminal for the current process
  #  if tty -s; then
  #    # To /dev/tty
  #    # No access if you're running the script in a non-interactive environment
  #    echo "/dev/tty"
  #    return
  #  fi
  #
  # or? sh -c ": >/dev/tty" >/dev/null 2>&1
  # the `:` points means do nothing beyond expanding arguments and performing redirections. The return status is zero
  # https://www.gnu.org/software/bash/manual/bash.html#index-_003a
  #
  # exec solution do a stdio redirection, therefore it needs to be between parenthesis
  # so that it does not pollute the environment
  # if (exec < /dev/tty >/dev/null 2>&1); then
  #
  # check if /dev/tty is writable
  #if [ -w /dev/tty ]; then

  if (exec < /dev/tty > /dev/null 2>&1) > /dev/null 2>&1; then
    echo "/dev/tty"
    return
  fi

  # No stdout
  # Why?
  # Command such as the below would not stop
  # They would just process `stdout` of the command and of the trap if any
  # ```bash
  # for var in $(command_with_echo_error)
  # ```

  if [ -t 2 ]; then
    echo "/dev/stderr"
    return
  fi

  # SSH session
  SSH_TTY=${SSH_TTY:-}
  if [ "$SSH_TTY" != "" ]; then
    echo "$SSH_TTY"
    return
  fi

  # May works
  echo "/dev/stderr"

}

# @internal
# @description
#    The base function that do the work
#    Should be at the end for the documentation generation
#    Accept as first argument a flag --silent or -s to no echo anything
# @arg $1 --silent -s - no echo
function echo::base() {

  local MESSAGE=""
  local TYPE_MESSAGE=""
  local LOG_LEVEL="$BASHLIB_ECHO_INFO_LEVEL"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      "--silent" | "-s")
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
        ;;
    esac
  done

  # Level
  if [ "$BASHLIB_ECHO_LEVEL" -lt "$LOG_LEVEL" ]; then
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
    "$BASHLIB_COMMAND_TYPE")
      MESSAGE="Command: $MESSAGE"
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
  if [ "$BASHLIB_ECHO_LEVEL" == "$BASHLIB_ECHO_DEBUG_LEVEL" ]; then
    # The caller function displays:
    # * the line number,
    # * subroutine name,
    # * and source file corresponding
    #
    # `caller 0` returns the actual calling executing function
    # Because this is a base function that call all echo function we want at minima `caller 1`
    #
    # See https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-caller
    CALLER_ID=1
    while true; do
      if ! CALLER=$(caller $CALLER_ID); then
        break
      fi
      read -r LINE CALLING_FUNCTION CALLING_SCRIPT <<< "$CALLER"
      CALLING_SCRIPT=$(basename "$CALLING_SCRIPT")
      # We don't want to see bashlib call
      # Example: bashlib-command::eval_echo
      if [[ ! "${CALLING_SCRIPT}" =~ ^"bashlib" ]]; then
        break
      fi
      CALLER_ID=$((CALLER_ID + 1))
    done

    # We send all echo to the error stream
    # so that any redirection will not get them
    # this is the standard behaviour of git
    MESSAGE="$CALLING_SCRIPT::$CALLING_FUNCTION#$LINE: ${MESSAGE}"
  fi

  if ! FD=$(echo::get_file_descriptor); then
    echo "No device available for the message ${MESSAGE}"
    return 1
  fi

  if ! echo -e "${MESSAGE}" > "$FD"; then
    echo "Error executing: echo -e ${MESSAGE} > $FD"
    return 1
  fi

}
