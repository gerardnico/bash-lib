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

The bash-lib package contains the following libraries:

* [bashlib-echo.sh](docs/echo.md) - Echo functions
* [bashlib-ssh.sh](docs/ssh.md) - Ssh functions
* [bashlib-stack.sh](docs/stack.md) - CallStack/Frame functions
* [bashlib-script.sh](docs/script.md) - Script functions
* [bashlib-git.sh](docs/git.md) - Git functions


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


