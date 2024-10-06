# bashlib-echo documentation

A echo library to log info, error and warning message

## Overview

With this library, you will be able to log info, error and warning message.

## Index

* [echo::info](#echoinfo)
* [echo::err](#echoerr)
* [echo::success](#echosuccess)
* [echo::warn](#echowarn)

### echo::info

Echo an info message

#### Example

```bash
# Default terminal color
echo::info "My Info"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

### echo::err

Echo an error message in red by default.

You can choose the color by setting the `BASHLIB_ERROR_COLOR` env variable.

#### Example

```bash
export BASHLIB_ERROR_COLOR='\033[0;31m' # Optional in Bashrc
echo::err "My Error"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

### echo::success

Echo an success message in green

You can choose the color by setting the `BASHLIB_SUCCESS_COLOR` env variable.

#### Example

```bash
export BASHLIB_SUCCESS_COLOR='\033[0;32m' # Optional in bashrc
echo::success "My Info"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

### echo::warn

Function to echo text in yellow (for warnings)

You can choose the color by setting the `BASHLIB_WARNING_COLOR` env variable.

#### Example

```bash
export BASHLIB_WARNING_COLOR='\033[0;33m' # Optional in bashrc
echo::warn "My Warning"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

