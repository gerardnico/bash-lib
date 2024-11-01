% bashlib-ssh(1) Version Latest | bashlib-ssh
# bashlib-ssh documentation

A library of ssh function

## DESCRIPTION

The library entry is [ssh::agent_init](#sshagent_init) that start an ssh agent
and add keys

It creates only one ssh-agent process per system, 
rather than the norm of one ssh-agent per login session.

You only need to enter a passphrase once every time your machine is rebooted.

Note: ssh-agent enhances security by allowing you to use passphrase-protected SSH keys without
entering the passphrase every time. 
However, anyone with access to the agent’s socket and your user permissions can use the keys 
managed by the agent.

## Index

* [ssh::agent_start](#sshagent_start)
* [ssh::agent_load_env](#sshagent_load_env)
* [ssh::list_agent_keys](#sshlist_agent_keys)
* [ssh::add_keys](#sshadd_keys)
* [ssh::agent_state](#sshagent_state)
* [ssh::agent_kill](#sshagent_kill)
* [ssh::known_hosts_update](#sshknown_hosts_update)
* [ssh::get_key_fingerprint](#sshget_key_fingerprint)
* [ssh::is_key_in_agent](#sshis_key_in_agent)
* [ssh::get_secret_interactive](#sshget_secret_interactive)
* [ssh::get_identity](#sshget_identity)
* [ssh::get_conf](#sshget_conf)

### ssh::agent_start

Start an agent and store the env in a file passed as argument
When starting an agent, this function will create an ENV file
The env file contains:
* the [SSH_AUTH_SOCK](https://man.archlinux.org/man/ssh.1.en#SSH_AUTH_SOCK)
* and SSH_AGENT_PID env values
It's a wrapper around `eval "$(ssh-agent -s)"`

#### Example

```bash
ssh::agent_start
# after the agent start, you would get
SSH_AUTH_SOCK=/tmp/ssh-XXXXXXVv4IgB/agent.17882; export SSH_AUTH_SOCK;
SSH_AGENT_PID=17883; export SSH_AGENT_PID;
echo Agent pid 17883;
```

#### Arguments

* **$1** (-): The env file path (default to `$SSH_ENV`)
* **$2** (-): The socket file path (default to `$SSH_AUTH_SOCK`)

### ssh::agent_load_env

Load the agent env

#### Exit codes

* **0**: - always

### ssh::list_agent_keys

List the available keys in the agent

### ssh::add_keys

This function will load keys that are:
* non-protected
* protected where the passphrase is defined by env variables

**How it works?**

The function will loop through the environment variables with the `SSH_KEY_PASSPHRASE` prefix.

When it finds an env such as `SSH_KEY_PASSPHRASE_MY_KEY`, the function will:
* try to find a file at `~/.ssh/my_key`
* add it with the value of `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` as passphrase

### ssh::agent_state

returns the Agent_run_state

#### Output on stdout

* the agent state
  * 0 : agent running with key,
  * 1 : agent without key
  * 2 : agent not running

### ssh::agent_kill

Kill a running agent given by the SSH_AGENT_PID environment variable

#### Exit codes

* **1**: if the SSH_AGENT_PID is unknown or the agent could not be killed

### ssh::known_hosts_update

Creates the known hosts file with the github fingerprint.

### ssh::get_key_fingerprint

Get the key fingerprint of a key file

### ssh::is_key_in_agent

Check if the key is in the agent

### ssh::get_secret_interactive

Get a secret interactively

### ssh::get_identity

Get the identity conf, applies templating eventually to get
a real path to a key file

#### Output on stdout

* - the identity

### ssh::get_conf

Get a conf for a destination

#### Output on stdout

* - the value

