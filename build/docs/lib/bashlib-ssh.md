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

* [ssh::agent_load_env](#sshagent_load_env)
* [ssh::list_agent_keys](#sshlist_agent_keys)
* [ssh::agent_state](#sshagent_state)
* [ssh::agent_state_human](#sshagent_state_human)
* [ssh::agent_kill](#sshagent_kill)
* [ssh::known_hosts_update](#sshknown_hosts_update)
* [ssh::get_key_fingerprint](#sshget_key_fingerprint)
* [ssh::is_key_in_agent](#sshis_key_in_agent)
* [ssh::get_identity](#sshget_identity)
* [ssh::get_conf](#sshget_conf)

### ssh::agent_load_env

Load the agent env

#### Exit codes

* **0**: - always

### ssh::list_agent_keys

List the available keys in the agent

### ssh::agent_state

returns the Agent state in numeric format

#### Output on stdout

* the agent state
  * 0 : agent running with key,
  * 1 : agent without key
  * 2 : agent not running

### ssh::agent_state_human

Return the state of the agent has human description

#### Exit codes

* **1**: if the state is unknown

#### Output on stdout

* the human state description

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

### ssh::get_identity

Get the identity conf, applies templating eventually to get
a real path to a key file

#### Output on stdout

* - the identity

### ssh::get_conf

Get a conf for a destination

#### Output on stdout

* - the value

