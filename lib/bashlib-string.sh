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