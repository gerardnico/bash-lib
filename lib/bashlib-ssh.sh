# @name bashlib-ssh documentation
# @brief A library of ssh function
# @description
#     The library entry is [ssh::agent_init](#sshagent_init) that start an ssh agent
#     and add keys
#
#     It creates only one ssh-agent process per system, 
#     rather than the norm of one ssh-agent per login session.
#
#     You only need to enter a passphrase once every time your machine is rebooted.
#
#     Note: ssh-agent enhances security by allowing you to use passphrase-protected SSH keys without
#     entering the passphrase every time. 
#     However, anyone with access to the agent’s socket and your user permissions can use the keys 
#     managed by the agent.
#

# shellcheck source=./bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"


# @description Load the agent env
# @args $1 string the path to a SSH Agent env file
# @exitcode 0 - always
ssh::agent_load_env () {
	local ENV_FILE="${1}"
	if ! test -f "$ENV_FILE"; then
	  return
	fi
	# shellcheck disable=SC1090
	source "$ENV_FILE" >| /dev/null ;
}

# @description List the available keys in the agent
ssh::list_agent_keys(){
  # Fingerprint format
  ssh-add -l
  # Long format
  # ssh-add -L
}


# @description returns the Agent state in numeric format
# @stdout the agent state
#    * 0 : agent running with key,
#    * 1 : agent without key
#    * 2 : agent not running
#
ssh::agent_state(){

  ssh-add -l >| /dev/null 2>&1 && echo $? || echo $?
  
}

# @description Return the state of the agent has human description
# @stdout   the human state description
# @exitcode 1 if the state is unknown
ssh::agent_state_human(){
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
        echo  "Agent not running"
        return
        ;;
      *)
        echo "$SSH_X_AGENT_RUN_STATE is an Unknown State"
        return 1
    esac
}

# @description Kill a running agent given by the SSH_AGENT_PID environment variable
# @exitcode 1 if the SSH_AGENT_PID is unknown or the agent could not be killed
ssh::agent_kill(){

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
  curl --silent https://api.github.com/meta \
    | jq --raw-output '"github.com "+.ssh_keys[]' >> "$SSH_KNOWN_HOSTS_FILE"

  echo::info "Known Hosts file created"

}



# @description
#    Get the key fingerprint of a key file
#
# @args $1 - a path
#
ssh::get_key_fingerprint(){
  ssh-keygen -l -f "$1" | awk '{print $2}'
}

# @description
#    Check if the key is in the agent
#
# @args $1 - a path
ssh::is_key_in_agent(){
  ssh-add -l | awk '{print $2}' | grep -q "$(ssh::get_key_fingerprint "$1")"
}


# @description
#    Get the identity conf, applies templating eventually to get
#    a real path to a key file
#
# @args $1 - the user
# @args $2 - the host
# @stdout - the identity
ssh::get_identity(){

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
ssh::get_conf(){
  # Conf must be lowercase
  local CONF=${1,,}
  local USER=$2
  local HOST=$3
  local DESTINATION="$2@$3"
  local SSH_PATH=${BASHLIB_SSH_PATH:-'ssh'}

  $SSH_PATH -T -G "$DESTINATION" | grep "$CONF" | awk '{ print $2 }'
}