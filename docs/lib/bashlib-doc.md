% bashlib-doc(1) Version Latest | bashlib-doc
# bashlib-doc documentation

Library over documentation function

## DESCRIPTION

Library over documentation functions

## Index

* [doc::md_to_terminal](#docmd_to_terminal)

### doc::md_to_terminal

#### Example

```bash
{
cat << EOF
```bash
command option
```
EOF
} | doc::md_to_terminal -
```

#### Arguments

* **$1** (path): - a path or - for stdin

#### Output on stdout

* a man page like output

