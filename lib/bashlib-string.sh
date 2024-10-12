# @name bashlib-string documentation
# @brief Library on string manipulation functions
# @description Library of string manipulation functions



# @description
#    returns the elements separated by the standard IFS
#    This is for demonstration purpose as bash functions can not return an array
# @arg $1 the string
# @arg $2 the separator
# @stdout the elements separated by the standard IFS
# @example
#    # string::split implementation is:
#    local SEP=${2}
#    IFS="$SEP" read -ra ARRAY <<< "$1"
#    echo "${ARRAY[@]}"
string::split(){

  local SEP=${2}
  IFS="$SEP" read -ra ARRAY <<< "$1"
  echo "${ARRAY[@]}"

}

# @description trim the first argument
# @arg $1 the string to trim
string::trim(){
  # Works because bash automatically trims by assigning to variables and by
  # passing arguments
  echo "$1";
}

