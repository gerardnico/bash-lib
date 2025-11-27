# @name bashlib-ssh documentation
# @brief A library of ssh function
# @description
#     The library is used in [ssh-x](https://github.com/gerardnico/ssh-x)
#

# shellcheck source=./bashlib-echo.sh
source "bashlib-echo.sh"
# shellcheck source=./bashlib-command.sh
source "bashlib-command.sh"

# @description Load the agent env
# @args $1 string the path to a SSH Agent env file
# @exitcode 0 - always
ssh::agent_load_env() {
  local ENV_FILE="${1}"
  if ! test -f "$ENV_FILE"; then
    return
  fi
  # shellcheck disable=SC1090
  source "$ENV_FILE" >| /dev/null
}

# @description List the available keys in the agent
ssh::list_agent_keys() {
  # Fingerprint format
  ssh-add -l
  # Long format
  # ssh-add -L
}

# @description
#    Add a key to the agent
#
#    `SSH_ASKPASS` and `SSH_X_TIMEOUT` env can be set before to manage how the passphrase is asked
#
#    This is a `ssh-x` function, the key is located via `SSH_X_KEY_STORE` and `SSH_X_KEY_HOME`
#    The `ssh-x-env` should have been sourced to set this variable to non-null value.
#
# @args $1 string the base name of the private key (ie the relative name from SSH_X_KEY_HOME)
# @args $2 string the passphrase if any, the value is passed to the `SSH_ASKPASS` as `SSH_X_PASSPHRASE` env
# @exitcode 1 - if the file does not exist
# @example
#    # Non-interactive with a secret
#    SSH_X_TIMEOUT=5
#    SSH_ASKPASS=ssh-x-askpass-env
#    ssh::add_key id_rsa secret
#    # Interactive, the user enters the secret if any
#    ssh::add_key id_rsa
#
ssh::add_key() {

  PRIVATE_KEY_BASENAME=${1}
  SSH_X_PASSPHRASE=${2:-}

  # Note on SSH_ASKPASS
  #
  # IDE provide their own SSH_ASKPASS
  # example:
  # Intellij env:
  #   SSH_ASKPASS=/mnt/c/Users/ngera/AppData/Local/JetBrains/IntelliJIdea2024.1/tmp/intellij-ssh-askpass-wsl-Debian.sh
  # Content of the file intellij-ssh-askpass-wsl-Debian.sh
  #   #!/bin/sh
  #   export WSLENV=INTELLIJ_SSH_ASKPASS_HANDLER/w:INTELLIJ_SSH_ASKPASS_PORT/w:INTELLIJ_GIT_ASKPASS_HANDLER/w:INTELLIJ_GIT_ASKPASS_PORT/w:INTELLIJ_REBASE_HANDER_NO/w:INTELLIJ_REBASE_HANDER_PORT/w
  #   "/mnt/c/Idea/jbr/bin/java.exe" -cp "C:/Idea/lib/externalProcess-rt.jar" externalApp.nativessh.NativeSshAskPassApp "$@"
  #
  # We may provide the ssh-x-askpass-env to set it automatically
  #

  SSH_ASKPASS=${SSH_ASKPASS:-"ssh-x-askpass-prompt"}

  # Where to send stdout
  # It depends if this is a terminal or an ide
  ECHO_FD=$(echo::get_file_descriptor)

  # 60 seconds but when using ssh-x-askpass-env (auto mode)
  # the value is way less (5)
  SSH_X_TIMEOUT=${SSH_X_TIMEOUT:-60}

  PRIVATE_KEY=$SSH_X_KEY_HOME/$PRIVATE_KEY_BASENAME
  case "$SSH_X_KEY_STORE" in
    "pass")
      PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME/.password-store"}/$PRIVATE_KEY.gpg"
      if [ ! -f "$PASS_FILE" ]; then
        echo::err "The pass private key ($PASS_FILE) does not exist"
        return 1
      fi

      # Process Substitution
      FD_PRIVATE_KEY="<($SSH_X_PASS_STORE $PRIVATE_KEY)"

      ;;
    "file")
      if [ ! -f "$PRIVATE_KEY" ]; then
        echo::err "The private key ($PRIVATE_KEY) does not exist "
        return 1
      fi

      # https://man.openbsd.org/ssh_config#AddKeysToAgent
      SSH_X_LIFE=${SSH_X_LIFE:-15m}
      ADD_KEY_TO_AGENT_CONF=$(ssh::get_conf "AddKeysToAgent" "$USER" "$HOSTNAME")
      if [[ ! "$ADD_KEY_TO_AGENT_CONF" =~ "yes"|"no"|"ask" ]]; then
        SSH_X_LIFE=$ADD_KEY_TO_AGENT_CONF
      fi

      FD_PRIVATE_KEY=$PRIVATE_KEY

      ;;
    *)
      echo::err "The SSH_X_KEY_STORE value ($SSH_X_KEY_STORE) is not supported. It should be 'file' or 'pass'"
      return 2
      ;;
  esac

  echo::info "Adding Private Key ($PRIVATE_KEY) to agent for a lifetime of $SSH_X_LIFE seconds"
  if [ "$SSH_X_PASSPHRASE" != "" ]; then
    # May freeze due to SSH_ASKPASS_REQUIRE=force when the SSH_X_PASSPHRASE is not empty otherwise it will ask it at the terminal
    echo::info "  - Executing ssh-add (if the passphrase is incorrect, the execution will freeze for ${SSH_X_TIMEOUT} sec)"
  fi
  # stdout should be `Identity added:xxx`
  SSH_ADD_COMMAND="SSH_ASKPASS_REQUIRE=require SSH_ASKPASS=$SSH_ASKPASS SSH_X_PASSPHRASE=$SSH_X_PASSPHRASE ssh-add -t $SSH_X_LIFE $FD_PRIVATE_KEY  1>$ECHO_FD 2>&1"
  if ! timeout "$SSH_X_TIMEOUT" bash -c "$SSH_ADD_COMMAND"; then
    echo::err "Trying to add the private key $PRIVATE_KEY timed out with the SSH_ASKPASS=$SSH_ASKPASS."
    if [ "$SSH_X_PASSPHRASE" != "" ]; then
      echo::err "Bad Passphrase maybe is mainly the cause"
    fi
    echo::err "Command: $SSH_ADD_COMMAND"
    return 1
  fi
}

# @description returns the Agent state in numeric format
# @stdout the agent state
#    * 0 : agent running with key,
#    * 1 : agent without key
#    * 2 : agent not running
#
ssh::agent_state() {

  ssh-add -l >| /dev/null 2>&1 && echo $? || echo $?

}

# @description Return the state of the agent has human description
# @stdout   the human state description
# @exitcode 1 if the state is unknown
ssh::agent_state_human() {
  SSH_X_AGENT_RUN_STATE=$(ssh::agent_state)
  case $SSH_X_AGENT_RUN_STATE in
    0)
      echo "Agent running with key"
      return
      ;;
    1)
      echo "Agent running without key"
      return
      ;;
    2)
      echo "Agent not running"
      return
      ;;
    *)
      echo "$SSH_X_AGENT_RUN_STATE is an Unknown State"
      return 1
      ;;
  esac
}

# @description Kill a running agent given by the SSH_AGENT_PID environment variable
# @exitcode 1 if the SSH_AGENT_PID is unknown or the agent could not be killed
ssh::agent_kill() {

  if [[ "${SSH_AGENT_PID:-}" == "" ]]; then
    # Trying to get it via process name
    if ! SSH_AGENT_PID=$(pgrep ssh-agent); then
      echo::err "The SSH_AGENT_PID is unknown and no ssh-agent process could be found."
      echo::err "No agent stopped"
      return 1
    fi
    # Give access to ssh-agent
    export SSH_AGENT_PID
  fi

  ssh-agent -k

  # Delete env
  unset SSH_AGENT_PID
  unset SSH_AUTH_SOCK
  SSH_X_AGENT_ENV=${SSH_X_AGENT_ENV:-}
  if [ -f "$SSH_X_AGENT_ENV" ]; then
    rm -f "$SSH_X_AGENT_ENV"
  fi
  unset SSH_X_ENV

}

# @description Creates the known hosts file with the github fingerprint.
#
#
ssh::known_hosts_update() {

  SSH_KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"
  mkdir -p "$(dirname "$SSH_KNOWN_HOSTS_FILE")"
  ## Known Host
  curl --silent https://api.github.com/meta |
    jq --raw-output '"github.com "+.ssh_keys[]' >> "$SSH_KNOWN_HOSTS_FILE"

  echo::info "Known Hosts file created"

}

# @description
#    Get the key fingerprint of a key file
#
# @args $1 - a path
#
ssh::get_key_fingerprint() {
  ssh-keygen -l -f "$1" | awk '{print $2}'
}

# @description
#    Check if the key is in the agent
#
# @args $1 - a path
ssh::is_key_in_agent() {
  ssh-add -l | awk '{print $2}' | grep -q "$(ssh::get_key_fingerprint "$1")"
}

# @description
#    Get the identity conf, applies templating eventually to get
#    a real path to a key file
#
# @args $1 - the user
# @args $2 - the host
# @stdout - the identity
ssh::get_identity() {

  local USER=$1
  local HOST=$2
  local DESTINATION="$1@$2"
  local KEY

  KEY=$(ssh::get_conf "identity" "$USER" "$HOST")

  echo::debug "Key for destination before templating ($DESTINATION): $KEY"

  if [ "$USER" == "git" ]; then
    # A ssh performed by git
    echo::debug "GIT_PROTOCOL=${GIT_PROTOCOL:-}"
    # Example of SSH Git:
    # * SSH Git Fetch or Pull
    # ssh -o SendEnv=GIT_PROTOCOL git@github.com git-upload-pack 'gerardnico/ssh-x.git'
    # * SSH Git Push
    # ssh git@github.com git-receive-pack 'gerardnico/ssh-x.git'
  fi

  # Templating
  # Replace %r by user
  KEY=${KEY//%r/$USER}
  # Replace %n by Host
  KEY=${KEY//%h/$HOST}
  # Replace the tilde with the home
  KEY=${KEY/#\~/$HOME}

  echo "$KEY"
}

# @description
#    Get a conf for a destination
#
# @args $1 - the conf
# @args $2 - the user
# @args $3 - the host
# @stdout - the value
ssh::get_conf() {
  # Conf must be lowercase
  local CONF=${1,,}
  local USER=$2
  local HOST=$3
  local DESTINATION="$2@$3"
  local SSH_PATH=${BASHLIB_SSH_PATH:-'ssh'}

  $SSH_PATH -T -G "$DESTINATION" | grep "$CONF" | awk '{ print $2 }'
}
