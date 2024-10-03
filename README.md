# Bash Libs


## About

A collection of bash libraries:
* [color.sh](lib/color.sh) - Color Codes
* [echo.sh](lib/echo.sh) - Echo functions
* [error.sh](lib/error.sh) - Error handling
* [loader.sh](lib/loader.sh) - A loader for library script
* [ssh.sh](lib/ssh.sh) - SSH functions
* [stack.sh](lib/stack.sh) - CallStack/Frame functions
* [script.sh](lib/script.sh) - Script functions

## Usage

```bash
load lib.sh
# to load the echo library
load echo.sh
```

## How to install

### Get the libraries

You can get them:
* with Homebrew
```bash
brew install gerardnico/tap/bashlib
export BASH_LIB_DIR=/usr/local/lib
```
* or with a `Git Clone`
```bash
git clone https://github.com/gerardnico/bash-lib
export BASH_LIB_DIR=$PWD/bash-lib/lib
```

### Load the loader

In your `.bashrc` file:
```bash
source $BASH_LIB_DIR/loader.sh
```

Use the loader in your scripts to load the libraries:
```bash
load echo.sh
```


## Loader loading directories precedence order

The [loader](lib/loader.sh) will look into the following directories by order of priorities:
  * the calling script dir
  * `BASH_LIB_DIR` if set
  * `~/.local/lib`
  * `/usr/local/lib`
