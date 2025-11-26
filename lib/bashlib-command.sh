# @name bashlib-command
# @brief A library over command utilities
# @description
#     A list of command utilities
#
#

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")" && pwd)"
# shellcheck source=./bashlib-echo.sh
source "${SCRIPT_DIR}/bashlib-echo.sh"

# @description
#     Echo a command line and eval it
#
# @arg $1 string The command to echo and eval
# @example
#    command::echo_eval "echo 'Hello World'"
#
# @stderr The command`
command::echo_eval(){
  echo::eval "$1"
}

# @description
#     Deprecated. The level is now controlled used command::echo_eval or echo::eval
#
# @stderr The command`
command::echo_debug_eval(){
  command::echo_eval "$1"
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

