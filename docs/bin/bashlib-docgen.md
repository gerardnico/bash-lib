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

* For a library:
  * the markdown file are generated via [shdoc](https://github.com/reconquest/shdoc)
  * no manpage is generated
* For a script:
  * you need to create a pandoc markdown file manually in `docs/bin`. Example of pandoc file with [pandoc metadata](https://pandoc.org/MANUAL.html#metadata-blocks)
```markdown
% your-script-name(1) Version 1.0.0 | The title
# NAME
# SYNOPSIS
# ....
```
  * The man pages are generated into `docs/man/man1`
  * You can add in your help function
```bash
help_usage(){
  qman "$(basename $0)"
}
```



## SYNOPSIS


```bash
bashlib-docgen [-o outputDir] [bashDir1 bashDir2 ...]
```

where:

* `-o`      - is the output directory (default to `docs`)
* `-h`      - shows this help
* `bashDir` - one or more directories with bash scripts or libraries (default to `lib` and `bin`)

