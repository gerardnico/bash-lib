# Bash Libs

## About

A collection of:

* [bash libraries](#where-is-the-library-documentation)
* and [documentation generation script](#where-is-the-script-documentation)
  to create bash script.

## Example

### Colorized message

After [installation](#how-to-install), you would use the [bashlib-echo.sh library](docs/lib/bashlib-echo.md) and output
an error:

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

* [bashlib-array.sh](docs/lib/bashlib-array.md) - Array functions (join, ...)
* [bashlib-bash.sh](docs/lib/bashlib-bash.md) - Bash functions (is interactive, trap, ...)
* [bashlib-cd.sh](docs/lib/bashlib-echo.md) - Cd functions
* [bashlib-command.sh](docs/lib/bashlib-command.md) - Command functions (eval, ...)
* [bashlib-crypto.sh](docs/lib/bashlib-crypto.md) - Cryptographic functions (Key, Cert, ...)
* [bashlib-doc.sh](docs/lib/bashlib-doc.md) - Documentation functions
* [bashlib-echo.sh](docs/lib/bashlib-echo.md) - Echo functions (info, warning, error, tip, ...)
* [bashlib-error.sh](docs/lib/bashlib-error.md) - Error handler functions
* [bashlib-git.sh](docs/lib/bashlib-git.md) - Git functions
* [bashlib-linux.sh](docs/lib/bashlib-linux.md) - Linux functions
* [bashlib-path.sh](docs/lib/bashlib-path.md) - File System Path functions
* [bashlib-script.sh](docs/lib/bashlib-script.md) - Script functions (ie source)
* [bashlib-ssh.sh](docs/lib/bashlib-ssh.md) - Ssh functions
* [bashlib-stack.sh](docs/lib/bashlib-stack.md) - CallStack/Frame functions
* [bashlib-string.sh](docs/lib/bashlib-string.md) - String functions
* [bashlib-template.sh](docs/lib/bashlib-template.md) - Template functions
* [bashlib-vault.sh](docs/lib/bashlib-vault.md) - Retrieve secret from vault (hashicorp or pass)

## How to load a library in your script

Your script need to add the bash lib directory `BASH_LIB_PATH` in the `PATH`
as first element so that bash search will be quick

```bash
export PATH="$BASH_LIB_PATH:$PATH"
# Then
source bashlib-[name].sh
```

For instance to load the [echo library](docs/lib/bashlib-echo.md)

```bash
source bashlib-echo.sh
```

## How is BASH_LIB_PATH determined?

`BASH_LIB_PATH` is made available to your script:

* [with a shebang rewrite via the package manager](#shebang-rewrite-with-your-package-manager)
* [via your bashrc](#environment-variable-via-bashrc) as environment variable for local development
* [by default in distribution file](#known-location-in-your-distribution-file)

### Known location in your distribution file

In a distribution file, if your library is relative to your script in the `../lib` directory you can use this snippet

```bash
if [ "${BASH_LIB_PATH:-}" == "" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}" || echo "${BASH_SOURCE[0]}")")" && pwd)"
  BASH_LIB_PATH="$SCRIPT_DIR/../lib"
  if [ ! -d "$BASH_LIB_PATH" ]; then
    echo "BASH_LIB_PATH was not set and could not be found"
    exit 1
  fi
fi
```

### Shebang rewrite with your package Manager

In a package manager, you may need to inject it in the header at install time by replacing the shebang.

Example for `brew`, you can check our [formulae](contrib/release/brew/formula.rb.tpl) that will create this header:

```bash
#!/usr/bin/env bash
BASH_LIB_PATH="#{libexec}"
```

### Environment variable via bashrc

When developing, you can define it in your `~/.bashrc`

```bash
export BASH_LIB_PATH="$HOME/code/bash-lib"
```

## Cli using these libraries

* [direnv-ext](https://github.com/gerardnico/direnv-x) - Direnv Express - A direnv extension to get secret from vault
* [dock-x](https://github.com/gerardnico/dock-x) - Dock Express - Your docker command driven by environment variables
* [giture](https://github.com/gerardnico/giture) - Git With Feature - Command plugin/extensions (Git flow, back up
  GitHub, execute a
  command against multiple repositories, ...)
* [kubee](https://github.com/gerardnico/kubee) - Kubee - a framework to provision and manage a kubernetes
  cluster
* [ssh-x](https://github.com/gerardnico/ssh-x) - SSH Express - a framework to manage SSH connection

## How to install

### With Homebrew

```bash
brew install gerardnico/tap/bash-lib
```

### With Git

```bash
git clone https://github.com/gerardnico/bash-lib
# Add the script in the path
export PATH=$PWD/bash-lib/bin:$PATH
# Optionally
export BASH_LIB_PATH=$PWD/bash-lib/lib
```

## Where is the Script documentation?

This package get also the following scripts:

* [bashlib-docgen](docs/bin/bashlib-docgen.md) - Generate the documentation of bash scripts and libraries

## BASH_LIB_PATH Env

`BASH_LIB_PATH` is the directory of the libraries for the scripts.
It's optional as the script would locate the library relatively.
