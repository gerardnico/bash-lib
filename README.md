# Bash Libs


## About

A collection of bash libraries:
* [color.sh](lib/color.sh) - Color Codes
* [echo.sh](lib/echo.sh) - Echo functions
* [error.sh](lib/error.sh) - Error handling
* [ssh.sh](lib/ssh.sh) - SSH functions
* [stack.sh](lib/stack.sh) - CallStack/Frame functions
* [script.sh](lib/script.sh) - Script functions


## How to load a library

```bash
source lib.sh
# to load the echo library
source echo.sh
```

## How to install

### With Homebrew

* Install the libraries into
```bash
brew install gerardnico/tap/bashlib
```

### With a `Git Clone`

```bash
git clone https://github.com/gerardnico/bash-lib
# Add the libraries directory into your path
export PATH=$PWD/bash-lib/lib:$PATH
```
  


## Naming Conventions

We follow the [Google Shell Naming Convention](https://google.github.io/styleguide/shellguide.html).

