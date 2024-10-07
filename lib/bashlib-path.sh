# @name bashlib-path documentation
# @brief Library on file system path functions
# @description Library of file system path functions


# @description returns the file EXTENSION
# @arg $1 the file path
# @stdout the file EXTENSION without the dot (ie sh, doc, txt, ...) or the empty string
path::get_extension() {
    local FILE_PATH="$1"
    # Removes everything from the start of the string up to and including the last dot (.).
    # If there's no dot, it returns the whole string.
    local EXTENSION="${FILE_PATH##*.}"
    # Removes the original FILE_PATH from the result if there was no dot.
    echo "${EXTENSION#"$FILE_PATH"}"
}