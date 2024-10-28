# @name bashlib-bash documentation
# @brief Library for array function over bash
# @description
#    Array function
#    * the array is passed as arguments
#    * the options as options
#
#    This library can be used as example on how to perform any array operations
#


# @description Join an array with a separator
# @options --sep `sep` or -s `sep` - the character separator default to new line `\n`
# @args $1-N array - all other arguments
# @example
#    # Join/Print each argument in a new line
#    array::join hello world
#    # Join/Print each argument with a comma
#    array::join --sep , hello world
#    # Join an array with tabs
#    array::join --sep $'\t' "${ARRAY[@]}"
array::join(){
  args=$(getopt -l "sep:" -o "s:" -- "$@")
  # eval set to set the positional arguments back to $args
  eval set -- "$args"
  SEP=$'\n'
  while [[ $# -gt 0 ]]
  do
     case "$1" in
        "--sep"|"-s")
          shift
          SEP=$1
          shift
          ;;
        --)
          shift
          break
          ;;
     esac
  done
  IFS="$SEP"; echo "$*"
}

# @description Return the last element of the arguments
# @args $0-N array - all arguments
array::last(){
  echo  "${@: -1}"
}