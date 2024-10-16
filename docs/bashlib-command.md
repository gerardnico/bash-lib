# bashlib-command

A library over command utilities

## Overview

A list of command utilities

## Index

* [command::echo_eval](#commandecho_eval)
* [command::fzf](#commandfzf)

### command::echo_eval

Print a command line and eval it

#### Example

```bash
command::eval_echo "echo 'Hello World'"
```

#### Arguments

* **$1** (string): The command to echo and eval

#### Output on stderr

* The command`

### command::fzf

Pipe the command history to fuzzy search
A Ctrl-A with fzf but returning the command

#### Example

```bash
command::fzf
```

#### Output on stderr

* The command`

