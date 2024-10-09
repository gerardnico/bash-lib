# @name bashlib-string documentation
# @brief Library on string manipulation functions
# @description Library of string manipulation functions



# @description returns the elements separated by the standard IFS
# @arg $1 the string
# @arg $2 the separator
# @stdout the elements separated by the standard IFS
string::split(){

  local SEP=${2}
  IFS="$SEP" read -ra ARRAY <<< "$1"
  echo "${ARRAY[@]}"

}
