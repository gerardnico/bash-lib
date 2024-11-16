% bashlib-stack(1) Version Latest | bashlib-stack
# bashlib-stack documentation

Call stack function

## DESCRIPTION

Functions around the Bash-maintained `FUNCNAME`, `BASH_SOURCE` and `BASH_LINENO` arrays

## Index

* [stack::print](#stackprint)
* [stack::print_bash_source](#stackprint_bash_source)
* [stack::print_process_tree](#stackprint_process_tree)

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

### stack::print_process_tree

Print the stack of process tree until the init process

This is handy to get who is calling your script

- The first line is the session time
- the second is the pid
- the third is the command line

```
2024-11-16 20:23:42 - 31980 - /usr/bin/ssh -o SendEnv=GIT_PROTOCOL git@github.com git-upload-pack 'gerardnico/ssh-x.git'
2024-11-16 20:23:42 - 31979 - git -c color.ui=always fetch
2024-11-16 20:23:42 - 31978 - /bin/bash /home/admin/code/git-x/bin/git-exec fetch
2024-11-16 20:23:42 - 31656 - /bin/bash /home/admin/code/git-x/bin/git-exec fetch
2024-11-16 20:23:42 - 31655 - /usr/bin/git exec fetch
2024-11-16 20:23:42 - 31654 - bash /usr/local/sbin/git exec fetch
2024-11-16 20:23:42 - 2633 - -bash
2024-11-16 20:23:42 - 2632 - /init
2024-11-16 20:23:42 - 2631 - /init
2024-11-16 20:23:42 - 1 - /init
```

#### Example

```bash
stack::print_process_tree >> /tmp/audit-parent.log
```

