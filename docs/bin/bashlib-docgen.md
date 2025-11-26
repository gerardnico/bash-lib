% bashlib-docgen(1) Version Latest | Generate markdown and man page documentation
# NAME

A script that will generate markdown documentation from:

* a bash library 
* or a script

To generate man page from the generated markdown files, see [bashlib-mangen](bashlib-mangen.md)

## DESCRIPTION

With this script, you can generate documentation for:
* a library 
* or a script

A library:

* has no bash shebang
* is not executable
* has the extension \`sh\`

A script file:

* has a bash shebang
* is executable
* has a help option (\`-h\`) or command (\`help\`)

They are searched by default in the `bin` and `lib` directories.

## HOW IT WORKS

### For a library

  * the markdown file are generated via [shdoc](https://github.com/reconquest/shdoc)

### For a script

  * You need to create a pandoc markdown file manually. Example of pandoc file with [pandoc metadata](https://pandoc.org/MANUAL.html#metadata-blocks)
```markdown
% your-script-name(1) Version ${VERSION} | The title
# NAME
# SYNOPSIS
${SYNOPSIS}
# ....
```

## Tips for script

  * You can use your man page in your help function. Example:
```bash
help(){
  man "$(basename $0)"
}
```
  * Or you can use the `doc::help` utility with a `synopsis` function.
```bash
source bashlib-doc.sh
help(){
  doc::help "synopsis"
}
```
  * If a command called `synopsis` is found, `docgen` will substitute `${SYNOPSIS}` in your markdown
```markdown
# SYNOPSIS

${SYNOPSIS}
```
  * For your subcommand, you can use the `doc::help` utility
```bash
source bashlib-doc.sh
doc::help "synopsis_function_for_sub_command"
```

# Output

The docs output directory by default is `docs/docgen` to be able to create relative link to image

Why? If your documentation is in `docs/bin` for scripts, the link `![my image desc](../images/image.png)` will 
also be valid in a document located in `docs/docgen`


# SYNOPSIS

${SYNOPSIS_DOCGEN}

