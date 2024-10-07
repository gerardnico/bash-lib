# Bash Libs


## About

A collection of bash libraries.

## Example

```bash
source bashlib-echo.sh
echo::err "Oups"
```

## How to use a library

See each library documentation page for usage.

The `bash-lib` package contains the following libraries:

* [bashlib-echo.sh](docs/bashlib-echo) - Echo functions
* [bashlib-error.sh](docs/bashlib-error) - Error handler functions
* [bashlib-function.sh](docs/bashlib-function) - Function functions
* [bashlib-git.sh](docs/bashlib-git) - Git functions
* [bashlib-script.sh](docs/bashlib-script) - Script functions (ie source)
* [bashlib-ssh.sh](docs/bashlib-ssh) - Ssh functions
* [bashlib-stack.sh](docs/bashlib-stack) - CallStack/Frame functions


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


