#!/bin/bash


source bashlib-color.sh

# Echo an info message
function echo::info() {

  # The caller function displays:
  # * the line number,
  # * subroutine name,
  # * and source file corresponding
  #
  # `caller 0` returns the actual calling executing function
  #
  # See https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-caller
  read -r LINE CALLING_FUNCTION CALLING_SCRIPT <<< "$(caller 0)"
  CALLING_SCRIPT=$(basename "$CALLING_SCRIPT")

  # We send all echo to the error stream
  # so that any redirection will not get them
  # this is the standard behaviour of git
  echo -e "$CALLING_SCRIPT::$CALLING_FUNCTION#$LINE: ${1:-}" >&2

}

# Print the error message $1
echo::err() {
  echo::info "${RED}Error: $1${NC}"
}

# Function to echo text in green (for success messages)
echo::success() {
    echo::info -e "${GREEN}Success: $1${NC}"
}

# Function to echo text in yellow (for warnings)
echo::warn() {
    echo::info -e "${YELLOW}Warning: $1${NC}"
}

