% bashlib-bash(1) Version Latest | bashlib-bash
# bashlib-bash documentation

Library for function over bash

## DESCRIPTION

This command overrides the default trap function
and add the ability to set multiple traps for the same signal

## Index

* [bash::trap](#bashtrap)
* [bash::is_interactive](#bashis_interactive)
* [bash::is_login](#bashis_login)
* [bash::conf](#bashconf)
* [bash::function_definition](#bashfunction_definition)
* [bash::has_terminal](#bashhas_terminal)

### bash::trap

This command overrides the default trap function
and add the ability to set multiple traps for the same signal

### bash::is_interactive

check to see if a shell is interactive

#### Exit codes

* **0**: If the shell is interactive
* **1**: If the shell is non-interactive

### bash::is_login

Check if the shell is a login shell

#### Exit codes

* **0**: If the shell is a login shell
* **1**: If the shell is non-login shell

### bash::conf

Print the state/conf of the shell
* Is it an interactive shell or not
* Is it a login shell or not

### bash::function_definition

Print the function definition

### bash::has_terminal

Check if the script has a terminal

