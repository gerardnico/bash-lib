# Dev


## Naming Conventions

* We follow the [Google Shell Naming Convention](https://google.github.io/styleguide/shellguide.html).
* The library script have the `bashlib` prefix to mirror the commonly used of `lib` in library. Example `libatomic.so.1`

## Docs

The doc is generated with our own utility [bashlib-docgen](../../docs/bin/bashlib-docgen.md) 

It's a wrapper around [shdoc](https://github.com/reconquest/shdoc)
* Install:
```bash
brew install gerardnico/tap/shdoc
```
Use with [bashlib-docgen](../../bin/bashlib-docgen)
```bash
bashlib-docgen
# or only shdoc for one
shdoc < lib/bashlib-echo.sh > docs/echo.md
```

## Online commit

```bash
bin/bashlib-docgen && ga "commit message"
```
## Support

### Why my Library is installed as executable in Homebrew

* A: Because Homebrew checks for a shebang.
* R: Delete it
