# bashlib-shell documentation

Library of functions over the shell

## Overview

Library of functions over the shell

## Index

* [shell::is_interactive](#shellis_interactive)
* [shell::is_login](#shellis_login)
* [shell::conf](#shellconf)

### shell::is_interactive

check to see if a shell is interactive

#### Exit codes

* **0**: If the shell is interactive
* **1**: If the shell is non-interactive

### shell::is_login

Check if the shell is a login shell

#### Exit codes

* **0**: If the shell is a login shell
* **1**: If the shell is non-login shell

### shell::conf

Print the state/conf of the shell
* Is it an interactive shell or not
* Is it a login shell or not

