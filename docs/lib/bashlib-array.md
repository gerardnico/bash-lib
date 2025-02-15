% bashlib-array(1) Version Latest | bashlib-array
# bashlib-bash documentation

Library for array function over bash

## DESCRIPTION

Array function
* the array is passed as arguments
* the options as options

This library can be used as example on how to perform any array operations

## Index

* [array::join](#arrayjoin)
* [array::last](#arraylast)
* [array::count](#arraycount)

### array::join

Join an array with a separator

#### Example

```bash
# Bash wrapper
IFS="$SEP"; echo "$*"
# Join/Print each argument in a new line
array::join hello world
# Join/Print each argument with a comma
array::join --sep , hello world
# Join an array with tabs
array::join --sep $'\t' "${ARRAY[@]}"
```

### array::last

Return the last element of the arguments

#### Example

```bash
array::last "${MY_ARRAY[@]}"
# equivalent on a array directly in bash to
LAST=${MY_ARRAY[-1]}
```

### array::count

Return the count of arguments

#### Example

```bash
array::count "${MY_ARRAY[@]}"
# equivalent on a array directly in bash to
COUNT=${#MY_ARRAY[@]}
```

