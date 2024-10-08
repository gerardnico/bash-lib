# docgen documentation

A script that will generate documentation from a bash library or script

## Overview

With this script, you can generate bash documentation for a library or for a script
Check the usage:
* in the [help](#help) section
* or with its option `-h`



## Help


Usage of the cli bashlib-docgen

Generate markdown documentation from bash script or libraries

```bash
bashlib-docgen [-o outputDir] bashDir...
```

where:
* `-o`      - is the output directory (default to docs)
* `-h`      - shows this help
* `bashDir` - one or more directories with bash scripts or libraries (default to lib and bin)

A library:
* has no bash shebang
* is not executable
* has the extension `sh`

A script file:
* has a bash shebang
* is executable
* has a help option (`-h`) or command (`help`)

The output of the help is added to the documentation in a h2 section called `Help`
