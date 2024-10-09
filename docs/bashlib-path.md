# bashlib-path documentation

Library on file system path functions

## Overview

Library of file system path functions

## Index

* [path::get_extension](#pathget_extension)
* [path::list_recursively](#pathlist_recursively)
* [path::is_absolute](#pathis_absolute)
* [path::get_file_name](#pathget_file_name)

### path::get_extension

returns the file extension (ie the string after the first dot)

#### Arguments

* **$1** (the): file path
* **$2** (define): the point position to determine the extension:

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

