% bashlib-path(1) Version Latest | bashlib-path
# bashlib-path documentation

Library on file system path functions

## DESCRIPTION

Library of file system path functions

## Index

* [path::get_extension](#pathget_extension)
* [path::list_recursively](#pathlist_recursively)
* [path::is_absolute](#pathis_absolute)
* [path::get_file_name](#pathget_file_name)
* [path::get_directory_path](#pathget_directory_path)
* [path::get_absolute_path](#pathget_absolute_path)
* [path::get_current_directory_name](#pathget_current_directory_name)
* [path::create_temp_directory](#pathcreate_temp_directory)
* [path::get_temp_directory](#pathget_temp_directory)
* [path::get_file_name_without_extension](#pathget_file_name_without_extension)
* [path::relative_to](#pathrelative_to)

### path::get_extension

returns the file extension (ie the string after the first dot)

#### Arguments

* **$1** (the): file path
* **$2** (define): the parts of the extension returned:

#### Exit codes

* **0**: If a file was provided
* **1**: If a file was not provided

#### Output on stdout

* the file extension without the dot (ie sql.gz, sh, doc, txt, ...) or the empty string

### path::list_recursively

List file recursively from a directory

#### Arguments

* **$1** (the): start directory

### path::is_absolute

Tell if a path is absolute

#### Arguments

* **$1** (the): path

#### Exit codes

* **0**: if the path is absolute
* **1**: if the path is not absolute

### path::get_file_name

Return the file name (known as the base name)

#### Arguments

* **$1** (the): path

### path::get_directory_path

Return the directory path (known as the dirname)

#### Arguments

* **$1** (the): path

### path::get_absolute_path

Return the absolute path (known as the realpath)

#### Arguments

* **$1** (the): path

### path::get_current_directory_name

Return the current directory name

### path::create_temp_directory

Create a temporary directory
with [mktemp](http://www.mktemp.org/)

#### Arguments

* **$1** (string): - a prefix (temp by default)

### path::get_temp_directory

Get the temporary directory
with [mktemp](http://www.mktemp.org/)

#### Output on stdout

* the temporary directory (normally /tmp)

### path::get_file_name_without_extension

Get the file name up until the first point

#### Example

```bash
# The below would return foo-bar
path::get_file_name_without_extension foo/bar/foo-bar.md
```

#### Arguments

* **$1** (string): - a path

### path::relative_to

Get the file name up until the first point

Demo:
```bash
path::relative_to /a/b /a
```
would exit with the code `0` and the stdout `a`

#### Arguments

* **$1** (string): - the path
* **$2** (string): - the base path (a parent path if relative)

#### Exit codes

* **0**: number - if the path is relative to the base path
* **1**: number - if the path is not relative to the base path

#### Output on stdout

* the relative path

