% bashlib-string(1) Version Latest | bashlib-string
# bashlib-string documentation

Library on string manipulation functions

## DESCRIPTION

Library of string manipulation functions
Note that the syntax $'...' syntax enables interpretation of escape sequences

## Index

* [string::split](#stringsplit)
* [string::trim](#stringtrim)
* [string::is_blank](#stringis_blank)
* [string::set_bold](#stringset_bold)
* [string::set_underline](#stringset_underline)
* [string::set_color](#stringset_color)
* [string::start_with](#stringstart_with)
* [string::no_case_match](#stringno_case_match)

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

### string::is_blank

test if the string is blank (ie empty or only with space)

#### Arguments

* **$1** (the): string to test (true if not passed)

### string::set_bold

Set the string bold
To see the boldness you need to use the `echo` package or use `echo -e` on the output

#### Arguments

* **$1** (the): string

#### Output on stdout

* the text wrapped with ansi color code

### string::set_underline

Set the string underline
To see the underline you need to use the `echo` package or use `echo -e` on the output

#### Arguments

* **$1** (the): string

#### Output on stdout

* the text wrapped with ansi color code

### string::set_color

Set a color (an ascii code or red, green, yellow)
To see the color you need to use the `echo` package or use `echo -e` on the output

#### Arguments

* **$1** (the): color
* **$2** (the): string

#### Output on stdout

* the text wrapped with ansi color code

### string::start_with

Check if a string starts with a prefix

#### Arguments

* **$1** (the): string
* **$2** (the): prefix

#### Exit codes

* **0**: - if the string starts with
* **1**: - if the string does not starts with

### string::no_case_match

Check if a string matches without casing

#### Arguments

* **$1** (the): string
* **$2** (the): pattern

#### Exit codes

* **0**: - if the string match without casing
* **1**: - if the string does not match without casing

