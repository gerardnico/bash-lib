# @name bashlib-bash documentation
# @brief Library for function over bash

# shellcheck source=./bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"


# @description
#   This command overrides the default trap function
#   and add the ability to set multiple command for the same signal
#
# @args $1 string - the command (the code expression)
# @args $2-N names of signals
# @example
#   bash::trap 'popd >/dev/null' EXIT # EXIT executes also on error
#
bash::trap() {
  # You can't set multiple traps for the same signal, but you
  # can add to an existing trap:
  # We:
  # 1. Fetch the existing trap code using `trap -p`
  # 2. Add the command, separated by a semicolon or newline
  # 3. Set the trap to the result of 2

  local TRAP_EXPRESSION=$1;
  shift
  for TRAP_SIGNAL in "$@"; do
    local TRAP
    TRAP=$(trap -p "${TRAP_SIGNAL}")
    echo::debug "Previous Trap:\n$TRAP"
    if [ "$TRAP" != "" ]; then
      local PREVIOUS_TRAP_COMMAND
      # shellcheck disable=SC2016
      PREVIOUS_TRAP_COMMAND=$(trap -p "${TRAP_SIGNAL}" | xargs -l bash -c 'echo $2')
      echo::debug "Previous Trap Command\n$PREVIOUS_TRAP_COMMAND"
      TRAP_EXPRESSION=$(printf '%s;%s' "$PREVIOUS_TRAP_COMMAND" "${TRAP_EXPRESSION}")
    fi

    if [ "$BASHLIB_ECHO_LEVEL" -ge "$BASHLIB_ECHO_DEBUG_LEVEL" ]; then
        local fd;
        fd=$(echo::get_file_descriptor);
        TRAP_EXPRESSION="echo '$TRAP_SIGNAL Trap command executed: $TRAP_EXPRESSION' > $fd; ${TRAP_EXPRESSION}"
    fi
    echo::debug "Trap $TRAP_SIGNAL command added: $TRAP_EXPRESSION"
    trap -- "$TRAP_EXPRESSION" "${TRAP_SIGNAL}"

  done
}

# @description check to see if a shell is interactive
# @exitcode 0 If the shell is interactive
# @exitcode 1 If the shell is non-interactive
function bash::is_interactive(){
  # $- (the current set of options) includes i if bash is interactive
  # Ref: https://www.man7.org/linux/man-pages/man1/bash.1.html#INVOCATION
  # We could also use the `tty` command to check if this is a terminal (ie interactive)
  if [[ $- == *i* ]]; then
    echo::debug "The shell is interactive."
    return 0
  fi
  echo::debug "The shell is not interactive."
  return 1
}

# @description Check if the shell is a login shell
# @exitcode 0 If the shell is a login shell
# @exitcode 1 If the shell is non-login shell
function bash::is_login(){
  if shopt -q login_shell; then
      echo::debug "The shell is a login shell."
      return 0
  fi
  echo::debug "The shell is not a login shell."
  return 1
}


# @description Print the function definition
bash::function_definition(){
  type "$1"
}
# @description Type of variable
bash::type(){
  type "$1"
}

# @description
#    Check if the standard stream file descriptors (stdout, stdin, ...)
#    are of the terminal type (ie color is supported)
bash::has_terminal(){
  tty -s
}

# @description
#    Eval_Validate will validate the output of an env
#    Why ? The eval status is the status of the last command executed
#    if the first command executed has error, it will not see it
#    This function executes each command line and returns an error if any
#    You could also just use the content of the function to not execute each command 2 times
# @args $1 string - The eval statement
# @exitcode 0 If no command has error
# @exitcode 1 If a command has error
# @stdout The error if any
# @example
#   if ! ERROR=$(bash::eval_validate "$EVAL"); then
#     echo::err "Error on env"
#     echo::echo "$ERROR"
#     exit 1
#   fi
#   # eval will put the results of the evaluation in the scope
#   # we therefore need to eval it again
#   eval "$EVAL"
bash::eval_validate(){
  while IFS=$'\n' read -r STATEMENT; do
      if ! STDERR=$(eval "$STATEMENT" 2>&1); then
        echo::err "Error:"
        echo::err "  * Statement: \`$STATEMENT\`"
        echo::err "  * Message: \`$STDERR\`"
        return 1
      fi
  done <<< "$1"
}

# Pinentry Cli Env Constant
PINENTRY_CURSES="pinentry-curses"
PINENTRY_GNOME="pinentry-gnome3"
PINENTRY_READ="read"
PINENTRY_ZENITY="zenity"
PINENTRY_WHIPTAIL="whiptail"
# @description
#    Return the program that should ask for the pin/secret/password
#    Pinentry is a OpenPgp term that designs a program to ask a pin/secret/password
#    This function supports:
#    * read (console)
#    * pinentry-curses (console)
#    * pinentry-gnome3 (gui)
#    * zenity (gui)
#    * whiptail (gui)
# @exitcode 1 if no pinentry program could be found for the context
# @stdout The pinentry program name
bash::get_pinentry(){

  # if /dev/tty is available (ie in a textual terminal)
  # Note that GPG uses an env to determine if this is an interactive textual terminal session
  # export GPG_TTY=$(tty)
  if sh -c ": >/dev/tty" >/dev/null 2>/dev/null; then
    # the `:` points means
    # Do nothing beyond expanding arguments and performing redirections. The return status is zero
    # https://www.gnu.org/software/bash/manual/bash.html#index-_003a

    if [ -x "$(command -v "$PINENTRY_CURSES")" ]; then
      echo "$PINENTRY_CURSES"
      return
    fi

    # We use read with dev/tty if we can. Why?
    # With zenity with Git, you get:
    #   Error: Received disconnect from UNKNOWN port 65535:11: Bye Bye
    #   Disconnected from UNKNOWN port 65535
    #   fatal: Could not read from remote repository.
    if [ -x "$(command -v "$PINENTRY_READ")" ]; then
      echo::err "In a text terminal context, we could not found $PINENTRY_CURSES or $PINENTRY_READ"
      return 1
    fi
    echo "$PINENTRY_READ"
    return

  fi

  # In a Gui, Cli IDE
  if [ "${DBUS_SESSION_BUS_ADDRESS:-}" != "" ] && [ -x "$(command -v "$PINENTRY_GNOME")" ]; then
    # Why Pinentry Gnome, because it may fall back to curses
    # Example: No $DBUS_SESSION_BUS_ADDRESS found, falling back to curses
    echo "$PINENTRY_GNOME"
    return
  fi
  if [ -x "$(command -v "$PINENTRY_ZENITY")" ]; then
    echo "$PINENTRY_ZENITY"
    return
  fi
  if [ -x "$(command -v "$PINENTRY_WHIPTAIL")" ]; then
     echo "$PINENTRY_WHIPTAIL"
     return
  fi

  echo::err "In a GUI/IDE setting, we could not found the pin client $PINENTRY_ZENITY or $PINENTRY_WHIPTAIL. Please install one of those."
  return 1


}

# @description
#    Ask for a pin/secret/password for the passed pinentry program
#    This function would be called in combination with the `get_pinentry` function
#
# @example
#    bash::get_pin "$(bash::get_pinentry)"
#
# @args $1 string - The pinentry program
# @args $2 string - The prompt
# @exitcode 1 if no pin or a cancel has occurred
# @exitcode 2 for any other errors (ie no args, unknown pinentry, ...)
# @stdout The pin
bash::get_pin(){

  PINENTRY=${1:-}
  if [ "${PINENTRY}" == "" ]; then
    echo::err "A pinentry program is mandatory"
    return 2
  fi
  PROMPT=${2:-"Enter the pin/secret/passphrase"}
  TIMEOUT=30

  case "$1" in
    "$PINENTRY_ZENITY")
      # on Windows, the width is not supported
      WIDTH=${#PROMPT} # number of characters
      if ! PASSWORD=$(zenity --password --title="$PROMPT" --width="$WIDTH" --timeout="$TIMEOUT" 2>/dev/null); then
        # https://help.gnome.org/users/zenity/stable/usage.html.en#zenity-usage-exitcodes
        case "$?" in
          1)
          echo::err "User has canceled"
          ;;
          -1)
          echo::err "An unexpected error has occurred"
          ;;
          5)
          echo::err "The dialog has been closed because the timeout has been reached."
          ;;
        esac
        return 1
      else
        echo "$PASSWORD"
      fi
      ;;
    "$PINENTRY_WHIPTAIL")
      whiptail --passwordbox "$1:" 8 78 3>&1 1>&2 2>&3
      ;;
    "$PINENTRY_READ")
      echo "$PROMPT" > /dev/tty
      read -r -s password < /dev/tty
      echo "$password"
      ;;
    "$PINENTRY_CURSES")
      pinentry-curses --ttyname "/dev/tty" --lc-ctype "$LANG" --timeout "$TIMEOUT" <<EOF | grep D | sed 's/^..//'
SETPROMPT $PROMPT
SETOK Ok
SETCANCEL Cancel
GETPIN
BYE
EOF
      ;;
    "$PINENTRY_GNOME")
       pinentry-gnome3 --ttyname "/dev/tty" --lc-ctype "$LANG" --timeout "$TIMEOUT"  <<EOF | grep D | sed 's/^..//'
SETPROMPT $PROMPT
SETOK Ok
SETCANCEL Cancel
GETPIN
BYE
EOF
          ;;
    *)
      echo:err "The pinentry value ($1) is unknown"
      exit 2
      ;;
  esac
}

