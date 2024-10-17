# @name bashlib-path documentation
# @brief Library on file system path functions
# @description Library of file system path functions

source bashlib-echo.sh



# @description returns the file extension (ie the string after the first dot)
# @arg $1 the file path
# @arg $2 define the parts of the extension returned:
#          * all from the first point to the end of the string
#          * first for the first part
#          * last for the last part (default)
# @stdout the file extension without the dot (ie sql.gz, sh, doc, txt, ...) or the empty string
# @exitcode 0 If a file was provided
# @exitcode 1 If a file was not provided
path::get_extension(){

  local FILE_NAME="$1"
  local PART_TYPE=${2:-'last'}

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

  IFS='.' read -ra PARTS <<< "$EXTENSION"
  case $PART_TYPE in
    'all')
      echo "$EXTENSION"
      return
    ;;
    'first')
      echo "${PARTS[0]}"
      return
    ;;
    'last')
      echo "${PARTS[@]: -1}"
      ;;
    *)
      echo:err "The part type ($PART_TYPE) is unknown (all, first or last)"
      return 1
      ;;
  esac


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

# @description Return the directory path (known as the dirname)
# @arg $1 the path
path::get_file_name(){
  dirname "$1"
}

# @description Return the absolute path (known as the realpath)
# @arg $1 the path
path::get_absolute_path(){
  realpath "$1"
}

# @description Return the current directory name
path::get_current_directory_name(){
  basename "$(pwd)"
}

# @description
#    Create a temporary directory
#    with [mktemp](http://www.mktemp.org/)
# @arg $1 string - a prefix (temp by default)
path::create_temp_directory(){
  PREFIX=${1:-"temp"}
  mktemp --directory --suffix="$PREFIX"
}

