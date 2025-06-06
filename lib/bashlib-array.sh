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
#    # Bash wrapper
#    IFS="$SEP"; echo "$*"
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
  # Not with IFS because it supports only 1 character
  # Below was deprecated
  # IFS="$SEP"; echo "$*"
  local result="$1"
  shift
  while (( $# > 0 )); do
    result="$result$SEP$1"
    shift
  done
  echo "$result"

}

array::length(){
  # ${#my_array[@]}
  echo "${#@}"
}
# @description Return the last element of the arguments
# @args $0-N array - all arguments
# @example
#    array::last "${MY_ARRAY[@]}"
#    # equivalent on a array directly in bash to
#    LAST=${MY_ARRAY[-1]}
array::last(){
  echo "${@: -1}"
}

# @description Return the count of arguments
# @args $0-N array - all arguments
# @example
#    array::count "${MY_ARRAY[@]}"
#    # equivalent on a array directly in bash to
#    COUNT=${#MY_ARRAY[@]}
array::count(){
  echo "${#[@]}"
}
