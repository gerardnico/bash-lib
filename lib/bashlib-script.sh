# @name bashlib-script documentation
# @brief Library of Script functions
# @description Library of Script functions

# shellcheck source=./bashlib-echo.sh
source "bashlib-echo.sh"

# @description check to see if this file is being run or sourced from another script
script::is_sourced() {

  # wrote the details here: https://unix.stackexchange.com/questions/214079/differentiating-between-running-and-being-sourced-in-a-bash-shell-script/790673#790673
  # basically the call `source filename` is added in the FUNCNAME array
  # so if the FUNCNAME array contains a `source` it was sourced
  for func in "${FUNCNAME[@]}"; do
    if [[ "$func" == "source" ]]; then
      return 0 # Sourced
    fi
  done
  return 1 # Not sourced

}

# @description check to see if this file is being run or sourced from another script
script::get_actual_script() {
  if ! script::is_sourced; then
    echo "$0"
    return
  fi
  # The last one in the array is the top script and the 0 one is the bashlib-script.sh
  echo "${BASH_SOURCE[1]}"
}

# @description check to see if a file has a shebang (ie is it a script or a library)
# @arg $1 the file path
# @exitcode 0 If the file has a shebang (ie is a bin script).
# @exitcode 1 If the file does not have any shebang
# @exitcode 2 If the file does not exist
script::has_shebang() {

  local FILE="$1"

  # Check if FILE exists
  if [[ ! -f "$FILE" ]]; then
    echo::err "File $FILE does not exist."
    return 2
  fi

  # Read the first line of the FILE
  read -r FIRST_LINE < "$FILE"

  # Check if the first line is a bash or sh shebang
  if [[ "$FIRST_LINE" == "#!"* ]]; then
    echo::debug "The file ($FILE) has a bash or sh shebang."
    return 0
  fi

  echo::debug "The file ($FILE) does not have a bash or sh shebang."
  return 1

}
