# @name bashlib-doc documentation
# @brief Library over documentation function
# @description Library over documentation functions
#
#

# @definition
#   Translate a markdown string to a terminal man page like doc. ie
#   * delete the code block and push the command to the right
#   * push the lists to the right
#   * add a marge of 5 space on the whole
# @arg $1 path - a path or - for stdin
# @stdout a man page like output
# @example
# {
# cat << EOF
# ```bash
# command option
# ```
# EOF
# } | doc::md_to_terminal -
#
doc::md_to_terminal(){
  FILE=${1:-}
  if [ "$FILE" == "-" ]; then
    FILE=/dev/stdin
  fi
  # Apply sed command on the whole document
  # then line by line
  sed -z \
        -e 's/```bash\n/\n    /g' \
        -e 's/```//g' \
        "$FILE" \
    |  sed \
      -e 's/\*/\   */g' \
      -e 's/^/     /g'

}

# @definition A method that expect a synopsis function and will return a basic usage
doc::usage(){

  {
  cat << EOF

Usage of $(basename "$0")

$(synopsis)

For more info, see $(basename "$0")(1)

EOF
  } | doc::md_to_terminal -
}

