% bashlib-docgen(1) Version Latest | Generate markdown and man page documentation
# NAME

A script that will generate markdown and man page documentation from:

* a bash library 
* or a script

## DESCRIPTION

With this script, you can generate documentation for a library or for a script

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

  * the markdown file are generated via [shdoc](https://github.com/reconquest/shdoc) into `docs/lib`
  * no manpage is generated

### For a script
  * you need to create a pandoc markdown file manually in `docs/bin`. Example of pandoc file with [pandoc metadata](https://pandoc.org/MANUAL.html#metadata-blocks)
```markdown
% your-script-name(1) Version 1.0.0 | The title
# NAME
# SYNOPSIS
${synopsis}
# ....
```
  * The bin pages are generated into `docs/bin-generated`
  * The man pages are generated into `docs/man/man1` and installed locally.

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

The bin docs output directory is in the same level below `docs` to be able to create relatif link to image

The link `![my image desc](../images/image.png)` will be valid in a document located in:
* `docs\bin` 
* `docs\bin-generated`


# SYNOPSIS

${SYNOPSIS_DOCGEN}

