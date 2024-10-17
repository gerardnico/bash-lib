# @name bashlib-string documentation
# @brief Library on string manipulation functions
# @description Library of string manipulation functions



# @description
#    returns the elements separated by the standard IFS
#    This is for demonstration purpose as bash functions can not return an array
#
#    Note if you want to split over multiple lines and for more than 1 character delimiter
#    you can use:
#    * [csplit](https://www.gnu.org/software/coreutils/manual/html_node/csplit-invocation.html#csplit-invocation)
#      It will create files. You can then iterate over them.
#      Example: [kube-cert](https://github.com/gerardnico/kube/bin/kube-cert) that splits a string into 2 PEM certificates.
#    * a full gawk script with RS (Record separator)
#    Why? because even if you succeed to split it, bash will always split by single character.
#
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

