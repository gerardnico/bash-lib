# Bash Libs


## About

A collection of bash libraries:
* [color](lib/bashlib-color.sh) - Color Codes
* [echo](lib/bashlib-echo.sh) - Echo functions
* [error](lib/bashlib-error.sh) - Error handling
* [ssh](lib/bashlib-ssh.sh) - SSH functions
* [stack](lib/bashlib-stack.sh) - CallStack/Frame functions
* [script](lib/bashlib-script.sh) - Script functions
* [git](lib/bashlib-git.sh) - Git functions


## How to load a library

```bash
source bashlib-[name].sh
# to load the echo library
source bashlib-echo.sh
```

## How to install


### With Homebrew

```bash
brew install --HEAD gerardnico/tap/bashlib
# Add the libraries directory into your path in your `.bashrc` file
export PATH=$(brew --prefix bashlib)/lib:$PATH
```

### With Git

```bash
git clone https://github.com/gerardnico/bash-lib
# Add the libraries directory into your path in your `.bashrc` file
export PATH=$PWD/bash-lib/lib:$PATH
```


## How to contribute? Dev Documentation

See [dev](test/dev.md)


