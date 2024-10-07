# bashlib-script documentation

Library of Script functions

## Overview

Library of Script functions

## Index

* [script::is_sourced](#scriptis_sourced)
* [script::has_shebang](#scripthas_shebang)

### script::is_sourced

check to see if this file is being run or sourced from another script

### script::has_shebang

check to see if a file has a shebang (ie is it a script or a library)

#### Arguments

* **$1** (the): file path

#### Exit codes

* **0**: If the file has a shebang (ie is a bin script).
* **1**: If the file does not have any shebang
* **2**: If the file does not exist

