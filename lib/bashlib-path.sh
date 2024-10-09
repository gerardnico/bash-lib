# @name bashlib-path documentation
# @brief Library on file system path functions
# @description Library of file system path functions

source bashlib-echo.sh



# @description returns the file extension (ie the string after the first dot)
# @arg $1 the file path
# @arg $2 define the point position to determine the extension:
#          * all from the first point to the end of the string
#          * first for the first part
#          * last for the last part (default)
# @stdout the file extension without the dot (ie sql.gz, sh, doc, txt, ...) or the empty string
# @exitcode 0 If a file was provided
# @exitcode 1 If a file was not provided
path::get_extension(){

  local FILE_NAME="$1"
  local POINT_POSITION=${2:-'last'}

  # Check if the file name is provided
  if [ -z "$FILE_NAME" ]; then
      echo:err "Error: No file name provided" >&2
      return 1
  fi

  if [ "$POINT_POSITION" = "first" ]; then

    # Extract everything after the first dot
    local EXTENSION="${FILE_NAME#*.}"

    # Check if there was a dot in the FILE_NAME
    if [ "$EXTENSION" = "$FILE_NAME" ]; then
        # No dot found, return empty string
        echo ""
        return
    fi
    echo "$EXTENSION"
    return

  fi

  # Extract characters after the last '.'
  local EXTENSION="${FILE_NAME##*.}"

  # Check if there was a '.' in the string
  if [[ "$EXTENSION" != "$FILE_NAME" ]]; then
      echo "$EXTENSION"
      return
  fi
  echo ""

}

# @description List file recursively from a directory
# @arg $1 the start directory
path::list_recursively(){
  find "$1"
}

# @description Tell if a path is absolute
# @arg $1 the path
# @exitcode 0 if the path is absolute
# @exitcode 1 if the path is not absolute
path::is_absolute(){
  if [[ "$1" == /* ]]; then
    return 0;
  fi
  return 1;
}

# @description Return the file name (known as the base name)
# @arg $1 the path
path::get_file_name(){
  basename "$1"
}
