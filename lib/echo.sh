#!/bin/bash

load color.sh
load stack.sh





# Echo an info message
function echo_info() {

  # We send all echo to the error stream
  # so that any redirection will not get them
  # this is the standard behaviour of git
  echo -e "$(calling_script): ${1:-}" >&2

}

# Print the error message $1
echo_err() {
  echo_info "${RED}Error: $1${NC}"
}

# Function to echo text in green (for success messages)
echo_success() {
    echo_info -e "${GREEN}Success: $1${NC}"
}

# Function to echo text in yellow (for warnings)
echo_warn() {
    echo_info -e "${YELLOW}Warning: $1${NC}"
}

