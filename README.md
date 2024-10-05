# Bash Libs


## About

A collection of bash libraries:
* [color](lib/bashlib-color.sh) - Color Codes
* [echo](lib/bashlib-echo.sh) - Echo functions
* [error](lib/bashlib-error.sh) - Error handling
* [ssh](lib/bashlib-ssh.sh) - SSH functions
* [stack](lib/bashlib-stack.sh) - CallStack/Frame functions
* [script](lib/bashlib-script.sh) - Script functions


## How to load a library

```bash
source bashlib-[name].sh
# to load the echo library
source bashlib-echo.sh
```

## How to install

### With Homebrew

* Install the libraries into
```bash
brew install --HEAD gerardnico/tap/bashlib
```

### With a `Git Clone`

```bash
git clone https://github.com/gerardnico/bash-lib
# Add the libraries directory into your path
export PATH=$PWD/bash-lib/lib:$PATH
```
  


## Naming Conventions

* We follow the [Google Shell Naming Convention](https://google.github.io/styleguide/shellguide.html).
* The library script have the `bashlib` prefix to mirror the commonly used of `lib` in library. Example `libatomic.so.1`

