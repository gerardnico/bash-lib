# @name bashlib-ssh documentation
# @brief A library of ssh function
# @description
#     The library entry is [ssh::agent_init](#sshagent_init) that start an ssh agent
#     and add keys



# @description
#    Start an agent and store the env in a file passed as argument
#    When starting an agent, this function will create an ENV file
#    The env file contains:
#    * the SSH_AUTH_SOCK
#    * and SSH_AGENT_PID env values
#    It's a wrapper around `eval "$(ssh-agent -s)"`
#
# @arg $1 - The env file path (default to `$SSH_ENV`)
# @arg $2 - The socket file path (default to `$SSH_AUTH_SOCK`)
# @example
#   ssh::agent_start
#   # after the agent start, you would get
#   SSH_AUTH_SOCK=/tmp/ssh-XXXXXXVv4IgB/agent.17882; export SSH_AUTH_SOCK;
#   SSH_AGENT_PID=17883; export SSH_AGENT_PID;
#   echo Agent pid 17883;
#
ssh::agent_start () {
	local ENV="${1:-$SSH_ENV}"
	local SOCK="${2:-$SSH_AUTH_SOCK}"
    echo Starting the ssh-agent with env at $ENV and sock at "$SSH_AUTH_SOCK"
    (umask 077; ssh-agent -a "$SOCK" >| "$ENV")
    . "$ENV" >| /dev/null ; 
}

# @description Load the env
ssh::agent_load_env () {
	local env="${1:-$SSH_ENV}"
	test -f "$env" && . "$env" >| /dev/null ; 
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
  ssh-add
	
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
	  echo "The SSH env variable $fullVariableName was found"
	  if [ -f "$filePath" ]; then
		echo "Trying to add the key $filename to the SSH agent"
		# The instruction is in the man page. SSH_ASKPASS needs a path to an executable
		# that emits the secret to stdout.
		# See doc: https://man.archlinux.org/man/ssh.1.en#SSH_ASKPASS
		SSH_ASKPASS="$HOME/.ssh/askpass.sh"
		echo "  - Creating the executable $SSH_ASKPASS"
		PASSPHRASE=$(eval "echo \$$SSH_VAR_PREFIX$var")
		printf "#!/bin/sh\necho %s\n" "$PASSPHRASE" > "$SSH_ASKPASS"
		chmod +x "$SSH_ASKPASS"
		TIMEOUT=5
		echo "  - Executing ssh-add (if the passphrase is incorrect, the execution will freeze for ${TIMEOUT} sec)"
		# freeze due to SSH_ASKPASS_REQUIRE=force otherwise it will ask it at the terminal
		BAD_PASSPHRASE_RESULT="Bad passphrase"
		result=$(timeout $TIMEOUT bash -c "DISPLAY=:0 SSH_ASKPASS_REQUIRE=force SSH_ASKPASS=$SSH_ASKPASS ssh-add $filePath" 2>&1 || echo "$BAD_PASSPHRASE_RESULT")
		echo "  - $result" # should be `Identity added:xxx`
		[ "$result" == "$BAD_PASSPHRASE_RESULT" ] && exit 1;
	  else
		echo "The env variable $fullVariableName designs a key file ($filePath) that does not exist" >&2
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

  ssh-add -l >| /dev/null 2>&1;
  echo $?;
  
}

# @description Kill a running agent
ssh::agent_kill(){
  ssh-agent -k
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
#    Start an agent and add keys if available
#
#    This is used in your `.bashrc` or env loading script
#
#    2 env variables are needed.
#    * The location of the env file
#    * The location of the agent socket file
#
#    For the key usage, see the [add_keys function](#sshadd_keys)
#
# @example
#    export SSH_ENV="$HOME"/.ssh/ssh-agent.env
#    export SSH_AUTH_SOCK="$HOME"/.ssh/agent.sock
#    SSH_KEY_PASSPHRASE_MY_KEY=secret
#    ssh::agent_init
#
# @see idea based on [auto-launching-ssh-agent-on-git-for-windows](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows)
ssh::agent_init(){

  # Load the env if available
  ssh::agent_load_env "$SSH_ENV"

  # Get the state
  local SSH_AGENT_RUN_STATE=$(ssh::agent_state)
  if [ ! "$SSH_AUTH_SOCK" ] || [ "$SSH_AGENT_RUN_STATE" = 2 ]; then
  	echo "Agent not started"
  	# The sock may be a symlink, so -e check that
  	# -f check only if it's a regular file
  	if [ -e "$SSH_AUTH_SOCK" ]; then
  	  echo "Deleting Sock file $SSH_AUTH_SOCK"
  	  rm "$SSH_AUTH_SOCK"
  	fi
  	echo "Starting Agent"
    ssh::agent_start "$SSH_ENV" "$SSH_AUTH_SOCK"
  	ssh::add_keys
  elif [ "$SSH_AUTH_SOCK" ] && [ "$SSH_AGENT_RUN_STATE" = 1 ]; then
  	echo Agent not started but empty
    ssh::add_keys
  fi

  unset SSH_ENV

}