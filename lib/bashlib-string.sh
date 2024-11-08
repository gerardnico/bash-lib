# @name bashlib-string documentation
# @brief Library on string manipulation functions
# @description Library of string manipulation functions
#    Note that the syntax $'...' syntax enables interpretation of escape sequences



# @description
#    returns the elements separated by the standard IFS
#    This is for demonstration purpose as bash functions can not return an array
#
#    Note if you want to split over multiple lines and for more than 1 character delimiter
#    you can use:
#    * [csplit](https://www.gnu.org/software/coreutils/manual/html_node/csplit-invocation.html#csplit-invocation)
#      It will create files. You can then iterate over them.
#      Example: [crypto::print_bundled_certificates_old](https://github.com/gerardnico/bash-lib/lib/bashlib-crypto.sh) that splits a string into 2 PEM certificates.
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

# @description test if the string is blank (ie empty or only with space)
# @arg $1 the string to test (true if not passed)
string::is_blank(){

  if [ $# -eq 0 ]; then
    return 0
  fi

  # remove the space and test if the length is 0
  [[ -z "${1// }" ]]

}

# ANSI color codes
BASHLIB_RED_COLOR=${BASHLIB_RED_COLOR:-'\033[0;31m'}
BASHLIB_GREEN_COLOR=${BASHLIB_GREEN_COLOR:-'\033[0;32m'}
BASHLIB_YELLOW_COLOR=${BASHLIB_YELLOW_COLOR:-'\033[0;33m'}
BASHLIB_BLUE_COLOR=${BASHLIB_BLUE_COLOR:-'\033[94m'}
NC='\033[0m' # No Color

# @description
#     Set the string bold
#     To see the boldness you need to use the `echo` package or use `echo -e` on the output
# @arg $1 the string
# @stdout the text wrapped with ansi color code
string::set_bold(){
  BOLD='\033[1m'
  echo "${BOLD}${1}${NC}"
}

# @description
#     Set the string underline
#     To see the underline you need to use the `echo` package or use `echo -e` on the output
# @arg $1 the string
# @stdout the text wrapped with ansi color code
string::set_underline(){
  UNDERLINE='\033[4m'
  echo "${UNDERLINE}${1}${NC}"
}

# @description
#     Set a color (an ascii code or red, green, yellow)
#     To see the color you need to use the `echo` package or use `echo -e` on the output
# @arg $1 the color
# @arg $2 the string
# @stdout the text wrapped with ansi color code
string::set_color(){

  COLOR=${1:-}
  case $COLOR in
    "red")
      COLOR="$BASHLIB_RED_COLOR"
      ;;
    "green")
      COLOR="$BASHLIB_GREEN_COLOR"
      ;;
    "yellow")
      COLOR="$BASHLIB_YELLOW_COLOR"
      ;;
    "blue")
      COLOR="$BASHLIB_BLUE_COLOR"
  esac
  echo "${COLOR}${2}${NC}"

}

# @description
#     Check if a string starts with a prefix
# @arg $1 the string
# @arg $2 the prefix
# @exitcode 0 - if the string starts with
# @exitcode 1 - if the string does not starts with
string::start_with(){
  # A pattern is never quoted, that's whey the ^ is not quoted
  [[ "${1}" =~ ^"${2}" ]]
}

# @description
#     Check if a string matches without casing
# @arg $1 the string
# @arg $2 the pattern
# @exitcode 0 - if the string match without casing
# @exitcode 1 - if the string does not match without casing
string::no_case_match(){
  # The parenthesis make the `shopt` local as it starts a subshell
  (
      shopt -s nocasematch;
      # shellcheck disable=SC2076
      [[ "$1" =~ "$2" ]]
  )
}

# @description
#     Add a marge (ie space at the beginning of each line)
# @arg $1 the size of the marge (default to 5)
# @example
#    echo "My String" | string::add_marge 4
string::add_marge(){
  MARGE=$(string::multiply ' ' "${1:-5}")
  # Set at the start of a line a number of spaces
  sed "s/^/$MARGE/"
}

# @description
#     Multiply a string by a count
# @arg $1 the string
# @arg $2 the count
string::multiply() {
  # ref https://stackoverflow.com/questions/38868665/multiplying-strings-in-bash-script
  local STRING="$1"
  local COUNT="$2"
  # No idea why but the * in %*s is important
  # shellcheck disable=SC2183
  printf -v PRINTF_COUNT '%*s' "$COUNT"
  printf '%s\n' "${PRINTF_COUNT// /$STRING}"
}

# @description
#     Get all characters before a character
#     Used generally when there is a separator such as a point or a backslash
#     It uses bash macro, you can also just look up and copy the code
# @arg $1 the string
# @arg $2 the character sep
string::get_all_characters_before(){
  # shellcheck disable=SC2317
  echo "${1##*"${2}"}"
}

# @description
#     Get all characters after a character
#     Used generally when there is a separator such as a point or a backslash
#     It uses bash macro, you can also just look up and copy the code
# @arg $1 the string
# @arg $2 the character sep
string::get_all_characters_after(){

  echo "${1%%"${2}"*}"

}

# @description
#     Transform a string to lowercase, to be used in a pipe
#
# @stdin - the text
# @stdout - the lowercase text
string::to_lowercase(){
  echo "${1,,}"
  # same as tr '[:upper:]' '[:lower:]'
}