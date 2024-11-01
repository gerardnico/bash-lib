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

* [bashlib-array.sh](build/docs/lib/bashlib-array.md) - Array functions (join, ...)
* [bashlib-bash.sh](build/docs/lib/bashlib-bash.md) - Bash functions (is interactive, trap, ...)
* [bashlib-cd.sh](build/docs/lib/bashlib-echo.md) - Cd functions
* [bashlib-command.sh](build/docs/lib/bashlib-command.md) - Command functions (eval, ...)
* [bashlib-crypto.sh](build/docs/lib/bashlib-crypto.md) - Cryptographic functions (Key, Cert, ...)
* [bashlib-doc.sh](build/docs/lib/bashlib-doc.md) - Documentation functions
* [bashlib-echo.sh](build/docs/lib/bashlib-echo.md) - Echo functions (info, warning, error, tip, ...)
* [bashlib-error.sh](build/docs/lib/bashlib-error.md) - Error handler functions
* [bashlib-git.sh](build/docs/lib/bashlib-git.md) - Git functions
* [bashlib-kube.sh](build/docs/lib/bashlib-kube.md) - Kubernetes functions
* [bashlib-linux.sh](build/docs/lib/bashlib-linux.md) - Linux functions 
* [bashlib-path.sh](build/docs/lib/bashlib-path.md) - File System Path functions
* [bashlib-script.sh](build/docs/lib/bashlib-script.md) - Script functions (ie source)
* [bashlib-ssh.sh](build/docs/lib/bashlib-ssh.md) - Ssh functions
* [bashlib-stack.sh](build/docs/lib/bashlib-stack.md) - CallStack/Frame functions
* [bashlib-string.sh](build/docs/lib/bashlib-stack.md) - String functions



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


