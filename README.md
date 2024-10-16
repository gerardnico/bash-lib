# Bash Libs


## About

A collection of:
* [bash libraries](#where-is-the-library-documentation) 
* and [utility scripts](#where-is-the-script-documentation)

## Example

After [installation](#how-to-install), you would use the [bashlib-echo.sh library](docs/bashlib-echo.md) and output an error:
```bash
source bashlib-echo.sh
echo::err "Oups"
```


## Where is the library documentation

See each library documentation page for usage.

The `bash-lib` package contains the following libraries:

* [bashlib-echo.sh](docs/bashlib-echo.md) - Echo functions
* [bashlib-error.sh](docs/bashlib-error.md) - Error handler functions
* [bashlib-eval.sh](docs/bashlib-eval.md) - A eval function that prints its commands
* [bashlib-function.sh](docs/bashlib-function.md) - Function functions
* [bashlib-git.sh](docs/bashlib-git.md) - Git functions
* [bashlib-key.sh](docs/bashlib-key.md) - Cryptographic Key functions
* [bashlib-kube.sh](docs/bashlib-kube.md) - Kubernetes functions
* [bashlib-path.sh](docs/bashlib-path.md) - File System Path functions
* [bashlib-shell.sh](docs/bashlib-shell.md) - Shell functions
* [bashlib-script.sh](docs/bashlib-script.md) - Script functions (ie source)
* [bashlib-string.sh](docs/bashlib-string.md) - String functions
* [bashlib-ssh.sh](docs/bashlib-ssh.md) - Ssh functions
* [bashlib-stack.sh](docs/bashlib-stack.md) - CallStack/Frame functions



## How to load a library

```bash
source bashlib-[name].sh
# to load the echo library
source bashlib-echo.sh
```

## Cli using these libraries

* [kube](https://github.com/gerardnico/kube) - A collection of Kubernetes Utilities
* [direnv-ext](https://github.com/gerardnico/direnv-ext) - A direnv extension to get secret from vault

## How to install


### With Homebrew

```bash
brew install --HEAD gerardnico/tap/bashlib
# Add the libraries and script directory into your path in your `.bashrc` file
export PATH=$(brew --prefix bashlib)/lib:$PATH
export PATH=$(brew --prefix bashlib)/bin:$PATH
```

### With Git

```bash
git clone https://github.com/gerardnico/bash-lib
# Add the libraries and script directory into your path in your `.bashrc` file
export PATH=$PWD/bash-lib/lib:$PATH
export PATH=$PWD/bash-lib/bin:$PATH
```

## Where is the Script documentation?

This package get also the following scripts:
* [bashlib-docgen](docs/bashlib-docgen.md) - Generate the documentation of bash scripts and libraries

## How to contribute? Dev Documentation

See [dev](dev/docs/dev.md)


