# @name bashlib-command
# @brief A library over command utilities
# @description
#     A list of command utilities
#
#

source bashlib-echo.sh

# @description
#     Print a command line and eval it
#
# @arg $1 string The command to echo and eval
# @example
#    command::eval_echo "echo 'Hello World'"
#
# @stderr The command`
command::echo_eval(){
  COMMAND=$1
  echo::info "Executing command: $COMMAND"
  eval "$COMMAND"
}


# @description
#     Pipe the command history to fuzzy search
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
command::escape_arg(){
  echo "$(printf '%q' "${1}")"
}