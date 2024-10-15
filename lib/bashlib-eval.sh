# @name bashlib-eval
# @brief A library over eval
# @description
#     A simple eval function to print and evaluate a command line
#
#

source bashlib-echo.sh

# @description
#     Print a command line and eval it
#
# @arg $1 string The command to eval
# @example
#    eval::command "echo 'Hello World'"
#
# @stderr The command`
eval::command(){
  COMMAND=$1
  echo::info "Executing command: $COMMAND"
  eval "$COMMAND"
}

