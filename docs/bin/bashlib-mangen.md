% bashlib-mangen(1) Version Latest | Generate markdown and man page documentation

# NAME

* Generate man page from markdown files with Pandoc
* And install them locally

This script is generally used after the execution of [bashlib-docgen](bashlib-docgen.md)

# PREREQUISITES

You need to have a directory of markdown files that have a man page header.

Example of pandoc file with [pandoc metadata](https://pandoc.org/MANUAL.html#metadata-blocks)

```markdown
% your-script-name(1) Version 1.0.0 | The title

# NAME
```

# SYNOPSIS

${SYNOPSIS}

# REF

* [Blog](https://eddieantonio.ca/blog/2015/12/18/authoring-manpages-in-markdown-with-pandoc/)
* [Example](https://raw.githubusercontent.com/eddieantonio/imgcat/refs/heads/master/docs/imgcat.1.md)
* [Pandoc Metadata starts with %](https://pandoc.org/MANUAL.html#metadata-blocks)
