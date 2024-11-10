# @name bashlib-kube
# @brief A library of kubernetes functions
# @description
#     A library of kubernetes functions
#
#

# shellcheck source=./bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"
# shellcheck source=./bashlib-command.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-command.sh"
# shellcheck source=./bashlib-bash.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-bash.sh"
# shellcheck source=./bashlib-path.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-path.sh"

# @description
#     Return the app label used to locate resources
#     It will return the label `app.kubernetes.io/name=<app name>`
#     This is the common app label as seen on the [common label page](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)
#
# @arg $1 string The app name
# @example
#    APP_LABEL="$(kube::get_app_label "$APP_NAME")"
#
# @stdout The app label ie `app.kubernetes.io/name=<app name>`
kube::get_app_label(){
  APP_NAME=$1
  echo "app.kubernetes.io/name=$APP_NAME"
}

# @description
#     Function to search for resources across all namespaces by app name
#     and returns data about them
#
# @arg $1 string `x`                  - the app name (mandatory) used in the label "app.kubernetes.io/name=$APP_NAME"
# @arg $2 string `--type x`           - the resource type: pod, ... (mandatory)
# @arg $3 string `--custom-columns x` - the custom columns (Default to `NAME:.metadata.name,NAMESPACE:.metadata.namespace`)
# @arg $4 string `--headers`          - the headers (Default to `no headers`)
# @example
#    PODS="$(kube::get_resources_by_app_name --type pod "$APP_NAME")"
#
#    PODS_WITH_NODE_NAME="$(kube::get_resources_by_app_name --type pod --custom-columns "NAME:.metadata.name,NAMESPACE:.metadata.namespace,NODE_NAME:.spec.nodeName" "$APP_NAME")"
#
# @stdout The resources data (one resource by line) or an empty string
kube::get_resources_by_app_name() {

  local APP_NAME=''
  local RESOURCE_TYPE=''
  local CUSTOM_COLUMNS='NAME:.metadata.name,NAMESPACE:.metadata.namespace'
  local NO_HEADERS="--no-headers"

  # Parsing the args
  while [[ $# -gt 0 ]]
  do
     case "$1" in
       "--type")
         shift
         RESOURCE_TYPE=$1
         shift
       ;;
      "--custom-columns")
         shift
         CUSTOM_COLUMNS=$1
         shift
      ;;
      "--headers")
        NO_HEADERS=""
        shift
      ;;
      *)
        if [ "$APP_NAME" == "" ]; then
          APP_NAME=$1
          shift
          continue
        fi
        if [ "$RESOURCE_TYPE" == "" ]; then
          RESOURCE_TYPE=$1
          shift
          continue
        fi
        echo::err "Too much arguments. The argument ($1) was unexpected"
        return 1
    esac
  done

  if [ "$APP_NAME" == "" ]; then
    echo::err "At least, the app name as argument should be given"
    return 1
  fi
  if [ "$RESOURCE_TYPE" == "" ]; then
    echo::err "The resource type is mandatory and was not found"
    return 1
  fi

  # App Label
  APP_LABEL=$(kube::get_app_label "$APP_NAME")

  #
  # Customs columns is a Json path wrapper.
  # Example:
  #     COMMAND="kubectl get $RESOURCE_TYPE --all-namespaces -l $APP_LABEL -o jsonpath='{range .items[*]}{.metadata.name}{\" \"}{.metadata.namespace}{\"\n\"}{end}' 2>/dev/null"
  #
  COMMAND="kubectl get $RESOURCE_TYPE --all-namespaces -l $APP_LABEL -o custom-columns='$CUSTOM_COLUMNS' $NO_HEADERS 2>/dev/null"
  echo::info "Executing: $COMMAND"
  eval "$COMMAND"

}

# @description
#     Function to search for 1 resource across all namespaces by app name
#     and returns data
#
# @arg $1 string `x`           - The app name
# @arg $2 string `--type type` - The resource type (pod, ...)
# @arg $3 string `--custom-columns x` - the custom columns (Default to `NAME:.metadata.name,NAMESPACE:.metadata.namespace`)
# @arg $4 string `--headers`          - the headers (Default to `no headers`)
# @example
#    read -r POD_NAME POD_NAMESPACE <<< "$(kube::get_resource_by_app_name --type pod "$APP_NAME" )"
#    if [ -z "$POD_NAME" ]; then
#        echo "Error: Pod not found with label $(kube::get_app_label $APP_NAME)"
#        exit 1
#    fi
#
# @stdout The resource name and namespace separated by a space or an empty string
# @exitcode 1 - if too many resource was found
kube::get_resource_by_app_name(){
  RESOURCES="$(kube::get_resources_by_app_name "$@")"
  RESOURCE_COUNT=$(echo "$RESOURCES" | sed '/^\s*$/d' | wc -l )
  if [ "$RESOURCE_COUNT" -gt 1 ]; then
      echo "Error: Multiple $RESOURCE_TYPE found with the label app.kubernetes.io/name=$APP_NAME:"
      echo "$RESOURCES"
      exit 1
  fi;
  echo "$RESOURCES"
}


# @description
#     Return a json path to be used in a `-o jsonpath=x` kubectl option
# @arg $1 string The Json expressions (Default to: `.metadata.name .metadata.namespace`)
kube::get_json_path(){
  JSON_DATA_PATH_EXPRESSIONS=${1:-'.metadata.name .metadata.namespace'}
  JSON_PATH='{range .items[*]}'
  for DATA_EXPRESSION in $JSON_DATA_PATH_EXPRESSIONS; do
    # shellcheck disable=SC2089
    JSON_PATH="$JSON_PATH$DATA_EXPRESSION{\" \"}"
  done;
  JSON_PATH="$JSON_PATH{\"\n\"}{end}"
  echo "$JSON_PATH"
}

# @description
#    Return the app directory
# @arg $1 string The app name
kube::get_app_dir(){

  KUBE_APP_NAME="$1"

  kube::check_app_home
  KUBE_APP_DIRECTORY=$KUBE_X_APP_HOME/$KUBE_APP_NAME

  if [ ! -d "$KUBE_APP_DIRECTORY" ]; then
    echo::err "The app directory $KUBE_APP_DIRECTORY does not exist"
    return 1
  fi

  echo "$KUBE_APP_DIRECTORY"


}

