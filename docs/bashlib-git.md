# bashlib-git documentation

Library of Git wrapper functions

## Overview

You would insert them in your `.bashrc` with `source bashlib-git.sh`

## Index

* [gs](#gs)
* [ga](#ga)
* [git-eol](#git-eol)

### gs

An alias function for `git status`

#### Example

```bash
gs
```

### ga

An alias function for `Git Add Commit and Push`

#### Example

```bash
ga "My Commit Message"
```

### git-eol

Normalize all file to a new line ending

#### Example

```bash
git-normalize-text
gs # to see the change file
ga "New line ending"
```

