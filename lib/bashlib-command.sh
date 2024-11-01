# @name bashlib-command
# @brief A library over command utilities
# @description
#     A list of command utilities
#
#

source bashlib-echo.sh

# @description
#     Echo a command line at the info level and eval it
#
# @arg $1 string The command to echo and eval
# @example
#    command::echo_eval "echo 'Hello World'"
#
# @stderr The command`
command::echo_eval(){
  COMMAND=$1
  echo::info "Executing command: $COMMAND"
  eval "$COMMAND"
}

# @description
#     Echo a command line at the debug level and eval it
#
# @arg $1 string The command to echo and eval
# @example
#    command::echo_debug_eval "echo 'Hello World'"
#
# @stderr The command`
command::echo_debug_eval(){
  COMMAND=$1
  echo::debug "Executing command: $COMMAND"
  eval "$COMMAND"
}

# @description
#     Pipe the command history to fuzzy search
#
#     Note that his function is already available natively with `Ctrl+R`
#
#     A Ctrl-A with fzf but returning the command
#
# @example
#    command::fzf
#
# @stderr The command
command::fzf(){
  history | cut -c 8- | fzf
}

# @description
#     Escape an argument
#     To avoid `syntax error near unexpected token `('`
#     when building command line syntax for eval
#
# @stderr The arg escaped
command::escape(){
  printf '%q' "${1}"
}

# @description
#     Check if a command exists
#
# @exitcode 0 if it exists
# @exitcode 1 if it does not exist
command::exists(){
  [ -x "$(command -v "$1")" ]
}

