# A loader for library script


load(){

  if [ -z "$1" ]; then
      echo "Usage: $0 <script name>"
      exit 1
  fi

  BASH_LIB_DIR=${BASH_LIB_DIR:-}
  if [ "$BASH_LIB_DIR" != "" ]; then
    SOURCE_DIRS+=("$BASH_LIB_DIR")
  fi

  #SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  USR_HOME_LOCAL_BASH_DIR="$HOME/.local/lib"
  SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null
  USR_LOCAL_DIR="/usr/local/lib"
  SOURCE_DIRS+=("$USR_HOME_LOCAL_BASH_DIR" "$SCRIPT_DIR" "$USR_LOCAL_DIR")

  for SOURCE_DIR in "${SOURCE_DIRS[@]}" ; do
    SOURCE_PATH="$SOURCE_DIR/$1"
    if [ -f "$SOURCE_PATH"  ]; then
        # shellcheck disable=SC1090
        source "$SOURCE_PATH"
        return
    fi
  done
  echo "Load: Script $1, not found in ${SOURCE_DIRS[*]}"
  return 1

}