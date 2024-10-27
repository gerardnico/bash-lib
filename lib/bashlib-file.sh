# @name bashlib-file documentation
# @brief Library on file content functions
# @description
#    Library of file content functions
#    For path function, check the `bashlib-path.sh` library
#
#    ## Dependencies
#
#    This library depends on the `file` utility
#    ```bash
#    sudo apt install -y file
#    ```


# @description
#   Get the mime
# @arg $1 string - a path
# @example
#    # The below would output: text/plain; charset=us-ascii
#    file::get_mime README.md
#
file::get_mime(){
  file -bi "$1"
}

# @description
#   Get the type as human description
# @arg $1 string - a path
# @example
#    # The below would output: ASCII text
#    path::get_type README.md
#
file::get_type(){
  file -b "$1"
}

# @description
#   Return if the file is a text file
# @arg $1 string - a path
# @example
#    # The below would output: ASCII text
#    path::is_text README.md
# @exitcode 0 if the file is a text file
# @exitcode 1 if the file is not a text file
file::is_text(){
  # the mime is `text/....; extra parameters'
  [[ "$(file -bi "$1")" =~ ^text ]]
}

# @description
#   Return if the file is an executable file (ELF, ...)
#   ie if the file is a compiled program or any understandable UNIX kernel format.
#   This function does not return the executable permission.
# @arg $1 string - a path
# @example
#    # The below would exit with the code 0
#    path::is_executable /usr/local/go/bin/go
# @exitcode 0 if the file is a executable file
# @exitcode 1 if the file is not a executable file
file::is_executable(){
  # the mime is `text/....; extra parameters'
  [[ "$(file -bi "$1")" =~ executable ]]
}

# @description
#   Return if the file permission in octal form (i 0600)
# @arg $1 string - a path
file::get_permission(){
  stat -c "%a" "$1"
}
