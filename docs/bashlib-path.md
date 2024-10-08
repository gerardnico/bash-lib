# bashlib-path documentation

Library on file system path functions

## Overview

Library of file system path functions

## Index

* [path::get_extension](#pathget_extension)

### path::get_extension

returns the file extension (ie the string after the first dot)

#### Arguments

* **$1** (the): file path

#### Exit codes

* **0**: If a file was provided
* **1**: If a file was not provided

#### Output on stdout

* the file extension without the dot (ie sql.gz, sh, doc, txt, ...) or the empty string

