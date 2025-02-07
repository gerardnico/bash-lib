% bashlib-command(1) Version Latest | bashlib-command
# bashlib-command

A library over command utilities

## DESCRIPTION

A list of command utilities

## Index

* [command::echo_eval](#commandecho_eval)
* [command::echo_debug_eval](#commandecho_debug_eval)
* [command::fzf](#commandfzf)
* [command::escape](#commandescape)
* [command::exists](#commandexists)

### command::echo_eval

Echo a command line and eval it

#### Example

```bash
command::echo_eval "echo 'Hello World'"
```

#### Arguments

* **$1** (string): The command to echo and eval

#### Output on stderr

* The command`

### command::echo_debug_eval

Deprecated. The level is now controlled used command::echo_eval or echo::eval

#### Output on stderr

* The command`

### command::fzf

Pipe the command history to fuzzy search

Note that his function is already available natively with `Ctrl+R`

A Ctrl-A with fzf but returning the command

#### Example

```bash
command::fzf
```

#### Output on stderr

* The command

### command::escape

Escape an argument
To avoid `syntax error near unexpected token `('`
when building command line syntax for eval

#### Output on stderr

* The arg escaped

### command::exists

Check if a command exists

#### Exit codes

* **0**: if it exists
* **1**: if it does not exist

