# Function around the Bash-maintained FUNCNAME array
# that is the function call stack.


# Prints the stack
# Start indice as args
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

# Print the bash source array
# The bash source array contains the script called by frames
# We use it to print the stack
#
# Example: Below:
#   * the script error_test (2)
#   * called a function in error_test (1)
#   * that called a function in stack.sh (0)
#
# BASH_SOURCE
# [0]: /home/admin/code/bash-lib/lib/stack.sh
# [1]: ./error_test
# [2]: ./error_test
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


#
# Callstack With Caller
# Arg: number
#
function stack::print_callers
{
    local _start_from_=0

    local params=( "$@" )
    if (( "${#params[@]}" >= "1" ))
        then
            _start_from_="$1"
    fi

    local i=0
    local first=false
    while caller $i > /dev/null
    do
        if test -n "$_start_from_" && (( "$i" + 1   >= "$_start_from_" ))
            then
                if test "$first" == false
                    then
                        echo "BACKTRACE IS:"
                        first=true
                fi
                caller $i
        fi
        i=$((i+1))
    done
}