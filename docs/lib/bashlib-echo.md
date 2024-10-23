% bashlib-echo(1) Version Latest | bashlib-echo
# bashlib-echo documentation

A echo library to log info, error and warning messages

## DESCRIPTION

With this library, you will be able to log info, error, debug and warning messages.

All messages are printed to `stderr` to not pollute any pipe redirection.

You can also define the message printed by setting the level via the `BASHLIB_LEVEL` environment
Setting it to:
* `0`: disable all messages
* `1`: print error messages
* `2`: print also warning messages
* `3`: print also info and success messages
* `4`: print also debug messages
By default, the library has the level `3` (info messages and up)

They all accept the flag `--silent` or `-s` to no echo anything

## Index

* [echo::info](#echoinfo)
* [echo::err](#echoerr)
* [echo::success](#echosuccess)
* [echo::warn](#echowarn)
* [echo::tip](#echotip)
* [echo::debug](#echodebug)
* [echo::conf](#echoconf)
* [echo::echo](#echoecho)

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

### echo::tip

Function to echo tip text

You can choose the color by setting the `BASHLIB_TIP_COLOR` env variable.

#### Example

```bash
export BASHLIB_TIP_COLOR='\033[0;33m' # Optional in bashrc
echo::tip "My tip"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

### echo::debug

Function to echo debug text

#### Example

```bash
echo::debug "My Debug statement"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

### echo::conf

Function that will output the environment configuration

### echo::echo

Function to echo without prefix to stderr

#### Example

```bash
echo::echo "My Debug statement"
```

#### Arguments

* **$1** (string): The value to print, by default an empty line

#### Exit codes

* **0**: Always

#### Output on stderr

* The output is always in stderr to avoid polluting stdout with log message (git ways)

