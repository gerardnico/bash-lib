% bashlib-bash(1) Version Latest | bashlib-bash
# bashlib-bash documentation

Library for function over bash

## DESCRIPTION

This command overrides the default trap function
and add the ability to set multiple command for the same signal

## Index

* [bash::trap](#bashtrap)
* [bash::is_interactive](#bashis_interactive)
* [bash::is_login](#bashis_login)
* [bash::function_definition](#bashfunction_definition)
* [bash::type](#bashtype)
* [bash::has_terminal](#bashhas_terminal)
* [bash::eval_validate](#basheval_validate)
* [bash::get_pinentry](#bashget_pinentry)
* [bash::get_pin](#bashget_pin)

### bash::trap

This command overrides the default trap function
and add the ability to set multiple command for the same signal

#### Example

```bash
bash::trap 'popd >/dev/null' EXIT # EXIT executes also on error
```

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

### bash::function_definition

Print the function definition

### bash::type

Type of variable

### bash::has_terminal

Check if the standard stream file descriptors (stdout, stdin, ...)
are of the terminal type (ie color is supported)

### bash::eval_validate

Eval_Validate will validate the output of an env
Why ? The eval status is the status of the last command executed
if the first command executed has error, it will not see it
This function executes each command line and returns an error if any
You could also just use the content of the function to not execute each command 2 times

#### Example

```bash
if ! ERROR=$(bash::eval_validate "$EVAL"); then
  echo::err "Error on env"
  echo::echo "$ERROR"
  exit 1
fi
# eval will put the results of the evaluation in the scope
# we therefore need to eval it again
eval "$EVAL"
```

#### Exit codes

* **0**: If no command has error
* **1**: If a command has error

#### Output on stdout

* The error if any

### bash::get_pinentry

Return the program that should ask for the pin/secret/password
Pinentry is a OpenPgp term that designs a program to ask a pin/secret/password
This function supports:
* read (console)
* pinentry-curses (console)
* pinentry-gnome3 (gui)
* zenity (gui)
* whiptail (gui)

#### Exit codes

* **1**: if no pinentry program could be found for the context

#### Output on stdout

* The pinentry program name

### bash::get_pin

Ask for a pin/secret/password for the passed pinentry program
This function would be called in combination with the `get_pinentry` function

#### Example

```bash
bash::get_pin "$(bash::get_pinentry)"
```

#### Exit codes

* **1**: if no pin or a cancel has occurred
* **2**: for any other errors (ie no args, unknown pinentry, ...)

#### Output on stdout

* The pin

