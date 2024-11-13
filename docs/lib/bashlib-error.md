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
* [error::set_strict_mode](#errorset_strict_mode)

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
source bashlib-error.sh # Import the library
error::strict_mode
error::set_trap
```

#### Variables set

* **trap** (for): error

### error::exit

Exit properly by deleting any ERR trap
even if the exit code is not 0
It's used to delete the print of a stack trace

#### Example

```bash
   # We don't want an error trace on this command
   # because we know that it's a bash script
   # that also print its own stack on error
   # To avoid a stack print on the main script, you would do
   sub_bash_script_with_error || error::exit $?
@args $1 - the exit code
```

### error::set_strict_mode

Set a strict mode
Same as
```bash
set -TCEeuo pipefail
```

