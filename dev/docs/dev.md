# Dev


## Naming Conventions

* We follow the [Google Shell Naming Convention](https://google.github.io/styleguide/shellguide.html).
* The library script have the `bashlib` prefix to mirror the commonly used of `lib` in library. Example `libatomic.so.1`

## Docs

The doc is generated with [shdoc](https://github.com/reconquest/shdoc)

Install:
```bash
brew install gerardnico/tap/shdoc
```
Use with [docgen](../bin/docgen)
```bash
docgen
# or for one
shdoc < ./bashlib-echo.sh > ../docs/echo.md
```

## Support

### Why my Library is installed as executable in Homebrew

* A: Because Homebrew checks for a shebang.
* R: Delete it
