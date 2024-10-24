# Bash Libs


## About

A collection of:
* [bash libraries](#where-is-the-library-documentation) 
* and [documentation generation script](#where-is-the-script-documentation)
to create bash script.

## Example

### Colorized message

After [installation](#how-to-install), you would use the [bashlib-echo.sh library](docs/lib/bashlib-echo.md) and output an error:
```bash
source bashlib-echo.sh
echo::err "Oups"
```

### Error traps

After [installation](#how-to-install), you would use the [bashlib-error.sh library](docs/lib/bashlib-error.md) 
and shows a stack trace if any error with:
```bash
set -Eeuo pipefail
source bashlib-error.sh
error::set_trap
```

## Where is the library documentation?

See each library documentation page for usage.

The `bash-lib` package contains the following libraries:

* [bashlib-cd.sh](docs/lib/bashlib-echo.md) - Cd functions
* [bashlib-command.sh](docs/lib/bashlib-command.md) - Command functions (eval, ...)
* [bashlib-crypto.sh](docs/lib/bashlib-crypto.md) - Cryptographic functions (Key, Cert, ...)
* [bashlib-echo.sh](docs/lib/bashlib-echo.md) - Echo functions (info, warning, error, tip, ...)
* [bashlib-error.sh](docs/lib/bashlib-error.md) - Error handler functions
* [bashlib-function.sh](docs/lib/bashlib-function.md) - Function functions
* [bashlib-git.sh](docs/lib/bashlib-git.md) - Git functions
* [bashlib-kube.sh](docs/lib/bashlib-kube.md) - Kubernetes functions
* [bashlib-linux.sh](docs/lib/bashlib-linux.md) - Linux functions 
* [bashlib-path.sh](docs/lib/bashlib-path.md) - File System Path functions
* [bashlib-script.sh](docs/lib/bashlib-script.md) - Script functions (ie source)
* [bashlib-shell.sh](docs/lib/bashlib-shell.md) - Shell functions
* [bashlib-ssh.sh](docs/lib/bashlib-ssh.md) - Ssh functions
* [bashlib-stack.sh](docs/lib/bashlib-stack.md) - CallStack/Frame functions
* [bashlib-string.sh](docs/lib/bashlib-stack.md) - String functions



## How to load a library

```bash
source bashlib-[name].sh
# to load the echo library
source bashlib-echo.sh
```

## Cli using these libraries

* [kube](https://github.com/gerardnico/kube) - A collection of Kubernetes Utilities
* [direnv-ext](https://github.com/gerardnico/direnv-ext) - A direnv extension to get secret from vault
* [dockenv](https://github.com/gerardnico/dockenv) - Your docker command driven by environment variables
* [git-x](https://github.com/gerardnico/git-x) - Git command plugin/extensions (back up Github, execute a command against multiple repositories, ...)

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
# Add the libraries and script directory into your path in your `.bashrc` file
export PATH=$PWD/bash-lib/lib:$PATH
export PATH=$PWD/bash-lib/bin:$PATH
```

## Where is the Script documentation?

This package get also the following scripts:
* [bashlib-docgen](docs/bin/bashlib-docgen.md) - Generate the documentation of bash scripts and libraries

## How to contribute? Dev Documentation

See [dev](dev/docs/dev.md)


