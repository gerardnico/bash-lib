# CONTRIBUTING

We follow this [GitHub contributing guideline](https://docs.github.com/en/contributing)

## Naming Conventions

* We follow the [Google Shell Naming Convention](https://google.github.io/styleguide/shellguide.html).
* The library script have the `bashlib` prefix to mirror the commonly used of `lib` in library. Example `libatomic.so.1`

## Docs

The doc is generated with our own utility [bashlib-docgen](docs/bin/bashlib-docgen.md)

It's a wrapper around [shdoc](https://github.com/reconquest/shdoc)

* Install:

```bash
brew install gerardnico/tap/shdoc
```

Use with [bashlib-docgen](bin/bashlib-docgen)

```bash
bashlib-docgen
# or only shdoc for one
shdoc < lib/bashlib-echo.sh > docs/echo.md
```
