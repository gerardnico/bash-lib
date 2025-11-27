# @name bashlib-doc documentation
# @brief Library over documentation function
# @description Library over documentation functions
#
#

# Depends on script to get the name of the actual script running (ie sourced or main)

# shellcheck source=./bashlib-script.sh
source "bashlib-script.sh"

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

# @definition
#   Return the cli commands words.
#
#   The cli commands words returned is the name of the script file exploded by the `-` separator
#
#   With a script file called `cli-command1-command2`, this function would return `cli command1 command2`
#
# @stdout the command words
# @example
#   CLI_COMMANDS=$(doc::get_cli_command_words)
#
doc::get_cli_command_words(){
  basename $(script::get_actual_script) | tr "-" " "
}

# @definition A method that expect a synopsis function and will return a basic usage
# @args $1 the synopsis method that prints the synopsis (by default synopsis)
# @args $2 the command (default to the prefix of the synopsis method or the script name if the method is called synopsis)
doc::help(){

  SYNOPSIS_METHOD=${1:-'synopsis'}
  COMMAND_NAME=${2:-}
  SEE_COMMAND_MAN=""
  if [ "$COMMAND_NAME" == "" ]; then
    if [ "$SYNOPSIS_METHOD" == 'synopsis' ]; then
      COMMAND_NAME=$(basename "$0")
      SEE_COMMAND_MAN="For more info, see $COMMAND_NAME(1)"
    else
      COMMAND_NAME=${SYNOPSIS_METHOD%%_*}
    fi
  fi
  # No carriage return between the title and the synopsis
  # as generally the synopsis is a heredoc that has a carriage return
  {
    cat << EOF

Usage of $COMMAND_NAME
$(eval "$SYNOPSIS_METHOD")

$SEE_COMMAND_MAN

EOF
  } | doc::md_to_terminal -

}
