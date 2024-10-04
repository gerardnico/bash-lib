# Function around the Bash-maintained FUNCNAME array
# that is the function call stack.


function stack::calling_script(){

  # caller return the LINE, the function and the script
  # example: 10 main /opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint
  # Syntax: caller EXPR
  # EXPR indicates how many call frames to go back before the current one
  # Caller returns 0 unless:
  #   * the shell is not executing a shell function
  #   * or EXPR is invalid:
  CLI_NAME=""
  if read -r LINE CALLING_FUNCTION CALLING_SCRIPT < "$(caller 1 > /dev/null)"; then
    # Name of the calling script
    CLI_NAME=$(basename "$CALLING_SCRIPT")
  fi
  echo "$LINE $CALLING_FUNCTION $CALLING_SCRIPT"
  if [ "$CLI_NAME" == "echo.sh" ] || [ "$CLI_NAME" == "" ]; then
    if read -r _ _ CALLING_SCRIPT < "$(caller 0)"; then
      CLI_NAME=$(basename "$CALLING_SCRIPT")
    fi
  fi

  if [ "$CLI_NAME" == "echo.sh" ] || [ "$CLI_NAME" == "" ]; then
    echo "main"
  fi
  echo "$CLI_NAME"

}

stack::print(){
  # CallStack with FUNCNAME
  # The FUNCNAME variable exists only when a shell function is executing.
  # The last element is `main` with the current script being 0

  # For enhancement the caller function can be used
  # caller displays the line number, subroutine name, and source file corresponding to that position in the current execution call stack
  # caller 0 will return the actual executing function
  # caller 1 will return the actual caller
  # It returns the function and the script
  # example: main /opt/dokuwiki-docker/bin/dokuwiki-docker-entrypoint
  # See https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-caller

  # If FUNCNAME has only one element, it's the main script
  # No stack print needed
  if [ ${#FUNCNAME[@]} = 1 ]; then
      return;
  fi
  echo::err "Call Stack:"
  for ((i=0; i < ${#FUNCNAME[@]}; i++)) do
      echo::err "  $i: ${BASH_SOURCE[$i]}#${FUNCNAME[$i]}:${BASH_LINENO[$i]}"
  done
}