# @name bashlib-stack documentation
# @brief Call stack function
# @description
#     Functions around the Bash-maintained FUNCNAME, BASH_SOURCE and BASH_LINENO arrays
#

# @description Prints the stack
# @arg $1 - the start indice as args
# @example
#   # if you don't want to print the function itself `stack::print` starts at 1
#   stack::print 1
#
stack::print(){
  # CallStack with FUNCNAME
  # The FUNCNAME variable exists only when a shell function is executing.
  # The last element is `main` with the current script being 0
  START_INDEX=${1:-0}
  # If FUNCNAME has only one element, it's the main script
  # No stack print needed
  if [ ${#FUNCNAME[@]} = 1 ]; then
      return;
  fi
  for ((i=START_INDEX; i < ${#FUNCNAME[@]}; i++)) do
      # On error, the index should be -1 to get the line
      indexLineNo=$((i -1))
      echo -e "   $i: ${BASH_SOURCE[$i]}#${FUNCNAME[$i]}:${BASH_LINENO[$indexLineNo]}"
  done
}

# @description
#     Print the bash source array
#
#     The bash source array contains the script called by frames.
#
#     We use it to print the stack
#
#     In the example, below
#     * the script error_test (2)
#     * called a function in error_test (1)
#     * that called a function in stack.sh (0)
#
# @example
#    BASH_SOURCE
#    [0]: /home/admin/code/bash-lib/lib/stack.sh
#    [1]: ./error_test
#    [2]: ./error_test
stack::print_bash_source(){

  if [ "${#BASH_SOURCE[@]}" -gt 0 ]; then
      echo "BASH_SOURCE elements:"
      for i in "${!BASH_SOURCE[@]}"; do
          echo -e "  * [$i]: ${BASH_SOURCE[$i]}"
      done
  else
      echo "BASH_SOURCE is not set or empty."
  fi

}
