# bashlib-stack documentation

Call stack function

## Overview

Functions around the Bash-maintained FUNCNAME, BASH_SOURCE and BASH_LINENO arrays

## Index

* [stack::print](#stackprint)
* [stack::print_bash_source](#stackprint_bash_source)

### stack::print

Prints the stack

#### Example

```bash
# if you don't want to print the function itself `stack::print` starts at 1
stack::print 1
```

#### Arguments

* **$1** (-): the start indice as args

### stack::print_bash_source

Print the bash source array

The bash source array contains the script called by frames.

We use it to print the stack

In the example, below
* the script error_test (2)
* called a function in error_test (1)
* that called a function in stack.sh (0)

#### Example

```bash
BASH_SOURCE
[0]: /home/admin/code/bash-lib/lib/stack.sh
[1]: ./error_test
[2]: ./error_test
```

