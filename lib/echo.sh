#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$SCRIPT_DIR/color.sh"
source "$SCRIPT_DIR/stack.sh"

# Echo an info message
function echo::info() {

  # We send all echo to the error stream
  # so that any redirection will not get them
  # this is the standard behaviour of git
  echo -e "$(stack::calling_script): ${1:-}" >&2

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

