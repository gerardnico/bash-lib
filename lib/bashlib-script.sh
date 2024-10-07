# @name bashlib-script documentation
# @brief Library of Script functions
# @description Library of Script functions

source bashlib-echo.sh

# @description check to see if this file is being run or sourced from another script
script::is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
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
    if [[ "$FIRST_LINE" == "#!/bin/bash"* || "$FIRST_LINE" == "#!/bin/sh"* ]]; then
        echo::debug "The file ($FILE) has a bash or sh shebang."
        return 0
    fi

    echo::debug "The file ($FILE) does not have a bash or sh shebang."
    return 1

}