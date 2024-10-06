# Bash Libs


## About

A collection of bash libraries:
* [echo](docs/echo.md) - Echo functions
* [error](docs/error.md) - Error handling
* [ssh](docs/ssh.md) - .md functions
* [stack](docs/stack.md) - CallStack/Frame functions
* [script](docs/script.md) - Script functions
* [git](docs/git.md) - Git functions


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

See [dev](dev/docs/dev.md)


