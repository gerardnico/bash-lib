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

# @description
#   This function will load keys that are:
#   * non-protected
#   * protected where the passphrase is defined by env variables
#
#   **How it works?**
#
#   The function will loop through the environment variables with the `SSH_KEY_PASSPHRASE` prefix.
#
#   When it finds an env such as `SSH_KEY_PASSPHRASE_MY_KEY`, the function will:
#	    * try to find a file at `~/.ssh/my_key`
#	    * add it with the value of `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` as passphrase
#
ssh::add_keys(){

  # add default non-protected keys from ~/.ssh
  ssh-add || echo::info "No non-protected keys found and added to agent"
	
	# Loop through the ANSIBLE_SSH_KEY_PASSPHRASE environment variables
	# and add the key to the agent
	# Example:
	# With the env `SSH_KEY_PASSPHRASE_MY_KEY` the script below will:
	# * try to find a file at `~/.ssh/my_key`
	# * add it with the value of `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` as passphrase
	#
	SSH_VAR_PREFIX='SSH_KEY_PASSPHRASE_'
	for var in $(printenv | grep -oP "^$SSH_VAR_PREFIX\K[^=]+")
	do
	  filename=$(echo "$var" | tr '[:upper:]' '[:lower:]')
	  fullVariableName="$SSH_VAR_PREFIX$var"
	  filePath=~/.ssh/"$filename"
	  echo::info "The SSH env variable $fullVariableName was found"
	  if [ -f "$filePath" ]; then
      echo::info "Trying to add the key $filename to the SSH agent"
      # The instruction is in the man page. SSH_ASKPASS needs a path to an executable
      # that emits the secret to stdout.
      # See doc: https://man.archlinux.org/man/ssh.1.en#SSH_ASKPASS
      SSH_ASKPASS="$HOME/.ssh/askpass.sh"
      echo::info "  - Creating the executable $SSH_ASKPASS"
      PASSPHRASE=$(eval "echo \$$SSH_VAR_PREFIX$var")
      printf "#!/bin/sh\necho %s\n" "$PASSPHRASE" > "$SSH_ASKPASS"
      chmod +x "$SSH_ASKPASS"
      TIMEOUT=5
      echo "  - Executing ssh-add (if the passphrase is incorrect, the execution will freeze for ${TIMEOUT} sec)"
      # freeze due to SSH_ASKPASS_REQUIRE=force otherwise it will ask it at the terminal
      BAD_PASSPHRASE_RESULT="Bad passphrase"
      result=$(timeout $TIMEOUT bash -c "DISPLAY=:0 SSH_ASKPASS_REQUIRE=force SSH_ASKPASS=$SSH_ASKPASS ssh-add $filePath" 2>&1 || echo "$BAD_PASSPHRASE_RESULT")
      echo::info "  - $result" # should be `Identity added:xxx`
      [ "$result" == "$BAD_PASSPHRASE_RESULT" ] && exit 1;
	  else
      echo::info "The env variable $fullVariableName designs a key file ($filePath) that does not exist" >&2
      exit 1;
	  fi
	done

}

# @description returns the Agent_run_state
# @stdout the agent state
#    * 0 : agent running with key,
#    * 1 : agent without key
#    * 2 : agent not running
#
ssh::agent_state(){

  ssh-add -l >| /dev/null 2>&1 && echo $? || echo $?
  
}

# @description Kill a running agent given by the SSH_AGENT_PID environment variable
# @exitcode 1 if the SSH_AGENT_PID is unknown or the agent could not be killed
ssh::agent_kill(){

  if [[ -z "$SSH_AGENT_PID" ]]; then
    # Trying to get it via process name
    SSH_AGENT_PID=$(pgrep ssh-agent)
    if [[ -z "$SSH_AGENT_PID" ]]; then
      echo::err "The SSH_AGENT_PID is unknown"
      return 1
    fi
    # Give access to ssh-agent
    export SSH_AGENT_PID
  fi

  ssh-agent -k

  # Delete env
  unset SSH_AGENT_PID
  unset SSH_AUTH_SOCK
  rm -f "$SSH_ENV"
  unset SSH_ENV

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