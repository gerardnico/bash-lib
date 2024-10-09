# @name bashlib-path documentation
# @brief Library on file system path functions
# @description Library of file system path functions

source bashlib-echo.sh



# @description returns the file extension (ie the string after the first dot)
# @arg $1 the file path
# @stdout the file extension without the dot (ie sql.gz, sh, doc, txt, ...) or the empty string
# @exitcode 0 If a file was provided
# @exitcode 1 If a file was not provided
path::get_extension(){

  local FILE_NAME="$1"

  # Check if the file name is provided
  if [ -z "$FILE_NAME" ]; then
      echo:err "Error: No file name provided" >&2
      return 1
  fi

  # Extract everything after the first dot
  local EXTENSION="${FILE_NAME#*.}"

  # Check if there was a dot in the FILE_NAME
  if [ "$EXTENSION" = "$FILE_NAME" ]; then
      # No dot found, return empty string
      echo ""
      return
  fi

  echo "$EXTENSION"

}

# @description List file recursively from a directory
# @arg $1 the start directory
path::list_recursively(){
  find "$1"
}