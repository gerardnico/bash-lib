# @name bashlib-template documentation
# @brief Library on templating functions
# @description Library of templating functions
#    Note that the syntax $'...' syntax enables interpretation of escape sequences



# @description
#   Check that all variables of a template are defined
# @args $1 $2 - `-f filepath`
# @args $1 - `a template string`
# @exitcode 1 if a variable found in the template string is not defined
# @stdout the variables not defined IFS separated
# @example
#    if ! UNDEFINED_VARS=$(template::check_vars "file/path/template"); then
#     for UNDEFINED_VAR in "${UNDEFINED_VARS[@]}"; do
#         echo "$UNDEFINED_VAR should be defined to template file/path/template"
#     done
#     exit 1
#    fi
#    envsubst < "file/path/template" >| "/dev/shem/template"
template::check_vars() {

  local TEMPLATE_STRING=""
  if [ "$1" == "-f" ]; then
    shift;
    if ! TEMPLATE_STRING="$(cat $1)"; then
      echo::err "The file $1 does not exist"
      return 1
    fi
  else
    TEMPLATE_STRING="$1"
  fi

  local ENVS=$(envsubst -v "$TEMPLATE_STRING")

  local rc=0
  local VARIABLES_NOT_DEFINED=()
  while read VARIABLE_NAME
  do
      if [ "${!VARIABLE_NAME:-}" == "" ]; then
          VARIABLES_NOT_DEFINED+=("$VARIABLE_NAME")
          rc=1
      fi
  done <<< $ENVS
  if [ "${#VARIABLES_NOT_DEFINED[@]}" -ne  0 ]; then
    echo "${VARIABLES_NOT_DEFINED[*]}"
  fi
  return "$rc"

}