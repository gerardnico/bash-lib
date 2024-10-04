# Bash Libs


## About

A collection of bash libraries:
* [color.sh](lib/color.sh) - Color Codes
* [echo.sh](lib/echo.sh) - Echo functions
* [error.sh](lib/error.sh) - Error handling
* [ssh.sh](lib/ssh.sh) - SSH functions
* [stack.sh](lib/stack.sh) - CallStack/Frame functions
* [script.sh](lib/script.sh) - Script functions

And a [libpath script](bin/libpath) - a loader helper for library script

## How to load a library

Use [libpath](bin/libpath) in your scripts to load the libraries:

```bash
source $(libpath lib.sh)
# to load the echo library
source $(libpath echo.sh)
```

## How to install

### With Homebrew

```bash
brew install gerardnico/tap/bashlib
```

### With a `Git Clone`

```bash
git clone https://github.com/gerardnico/bash-lib
export BASH_LIB_DIR=$PWD/bash-lib/lib
export PATH=$PWD/bash-lib/bin:$PATH
```



## libpath directories precedence order

The [libpath](bin/libpath) will look into the following directories by order of priorities:
  * the calling script dir
  * `BASH_LIB_DIR` if set
  * `~/.local/lib`
  * `/usr/local/lib`


## Naming Conventions

https://google.github.io/styleguide/shellguide.html
