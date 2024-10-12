# bashlib-string documentation

Library on string manipulation functions

## Overview

Library of string manipulation functions

## Index

* [string::split](#stringsplit)
* [string::trim](#stringtrim)

### string::split

returns the elements separated by the standard IFS
This is for demonstration purpose as bash functions can not return an array

#### Example

```bash
# string::split implementation is:
local SEP=${2}
IFS="$SEP" read -ra ARRAY <<< "$1"
echo "${ARRAY[@]}"
```

#### Arguments

* **$1** (the): string
* **$2** (the): separator

#### Output on stdout

* the elements separated by the standard IFS

### string::trim

trim the first argument

#### Arguments

* **$1** (the): string to trim

