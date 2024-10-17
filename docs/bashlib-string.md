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

Note if you want to split over multiple lines and for more than 1 character delimiter
you can use:
* [csplit](https://www.gnu.org/software/coreutils/manual/html_node/csplit-invocation.html#csplit-invocation)
It will create files. You can then iterate over them.
Example: [crypto::print_bundled_certificates_old](https://github.com/gerardnico/bash-lib/lib/bashlib-crypto.sh) that splits a string into 2 PEM certificates.
* a full gawk script with RS (Record separator)
Why? because even if you succeed to split it, bash will always split by single character.

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

