% bashlib-file(1) Version Latest | bashlib-file
# bashlib-file documentation

Library on file content functions

## DESCRIPTION

Library of file content functions
For path function, check the `bashlib-path.sh` library

## Dependencies

This library depends on the `file` utility
```bash
sudo apt install -y file
```

## Index

* [file::get_mime](#fileget_mime)
* [file::get_type](#fileget_type)
* [file::is_text](#fileis_text)
* [file::is_executable](#fileis_executable)

### file::get_mime

Get the mime

#### Example

```bash
# The below would output: text/plain; charset=us-ascii
file::get_mime README.md
```

#### Arguments

* **$1** (string): - a path

### file::get_type

Get the type as human description

#### Example

```bash
# The below would output: ASCII text
path::get_type README.md
```

#### Arguments

* **$1** (string): - a path

### file::is_text

Return if the file is a text file

#### Example

```bash
   # The below would output: ASCII text
   path::is_text README.md
@exitcode 0 if the file is a text file
@exitcode 1 if the file is not a text file
```

#### Arguments

* **$1** (string): - a path

### file::is_executable

Return if the file is an executable file (ELF, ...)
ie if the file is a compiled program or any understandable UNIX kernel format.
This function does not return the executable permission.

#### Example

```bash
   # The below would exit with the code 0
   path::is_executable /usr/local/go/bin/go
@exitcode 0 if the file is a executable file
@exitcode 1 if the file is not a executable file
```

#### Arguments

* **$1** (string): - a path

