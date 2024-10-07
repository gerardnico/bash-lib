# bashlib-ssh documentation

A library of ssh function

## Overview

The library entry is [ssh::agent_init](#sshagent_init) that start an ssh agent
and add keys

## Index

* [ssh::agent_start](#sshagent_start)
* [ssh::agent_load_env](#sshagent_load_env)
* [ssh::add_keys](#sshadd_keys)
* [ssh::agent_state](#sshagent_state)
* [ssh::agent_kill](#sshagent_kill)
* [ssh::known_hosts_update](#sshknown_hosts_update)
* [ssh::agent_init](#sshagent_init)

### ssh::agent_start

Start an agent and store the env in a file passed as argument
When starting an agent, this function will create an ENV file
The env file contains:
* the SSH_AUTH_SOCK
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

Load the env

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

Kill a running agent

### ssh::known_hosts_update

Creates the known hosts file with the github fingerprint.

### ssh::agent_init

Start an agent and add keys if available

This is used in your `.bashrc` or env loading script

2 env variables are needed.
* The location of the env file
* The location of the agent socket file

For the key usage, see the [add_keys function](#sshadd_keys)

#### Example

```bash
export SSH_ENV="$HOME"/.ssh/ssh-agent.env
export SSH_AUTH_SOCK="$HOME"/.ssh/agent.sock
SSH_KEY_PASSPHRASE_MY_KEY=secret
ssh::agent_init
```

#### See also

* idea based on [auto-launching-ssh-agent-on-git-for-windows](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows)

