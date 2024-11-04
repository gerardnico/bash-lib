% bashlib-error(1) Version Latest | bashlib-error
# bashlib-error documentation

Library to handle error in bash

## DESCRIPTION

With this library, you will be able to add an error handler
See the function [set_trap](#errorset_trap) for a usage example



Depends on stack to print the callstack
shellcheck source=./bashlib-stack.sh

## Index

* [error::handler](#errorhandler)
* [error::set_trap](#errorset_trap)
* [error::exit](#errorexit)

### error::handler

An error handling function that will print:
* The command in error
* The exit status
* And error location information
* The source file
* The function
* The line
This function is called by the error:set_trap

#### Example

```bash
# used in the error:set_trap function
error::handler "$?" "$BASH_COMMAND" "${BASH_SOURCE[0]}" "${FUNCNAME[0]}" $LINENO
```

#### Arguments

* **$1** (-): the error code
* **$2** (-): the file source
* **$3** (-): the function name
* **$4** (-): the line number

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

### error::set_trap

Add the error handler via the creation of a error trap
In your script, we advise to set the error option. See example.

#### Example

```bash
set -Eeuo pipefail # A onliner
# where the flag means:
#   e - Exit if any error
#   u - Treat unset variables as an error when substituting
#   o pipefail - the return value of a pipeLOCATION is the status of the last command to exit with a non-zero status or zero if no command exited with a non-zero status
#   E - the ERR trap is inherited by shell functions
source bashlib-error.sh # Import the library
error:set_trap
```

#### Variables set

* **trap** (for): error

### error::exit

Exit properly by deleting any ERR trap
even if the exit code is not 0

