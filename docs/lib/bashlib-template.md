% bashlib-template(1) Version Latest | bashlib-template
# bashlib-template documentation

Library on templating functions

## DESCRIPTION

Library of templating functions
Note that the syntax $'...' syntax enables interpretation of escape sequences

## Index

* [template::check_vars](#templatecheck_vars)

### template::check_vars

Check that all variables of a template are defined

#### Example

```bash
if ! UNDEFINED_VARS=$(template::check_vars "file/path/template"); then
 for UNDEFINED_VAR in "${UNDEFINED_VARS[@]}"; do
     echo "$UNDEFINED_VAR should be defined to template file/path/template"
 done
 exit 1
fi
envsubst < "file/path/template" >| "/dev/shem/template"
```

#### Exit codes

* **1**: if a variable found in the template string is not defined

#### Output on stdout

* the variables not defined IFS separated

