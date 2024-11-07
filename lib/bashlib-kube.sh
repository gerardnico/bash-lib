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
  KUBE_APP_DIRECTORY=$KUBE_APP_HOME/$KUBE_APP_NAME

  if [ ! -d "$KUBE_APP_DIRECTORY" ]; then
    echo::err "The app directory $KUBE_APP_DIRECTORY does not exist"
    return 1
  fi

  echo "$KUBE_APP_DIRECTORY"


}

# @description
#    Check if KUBE_APP_HOME is set
kube::check_app_home(){
  if [ -z "$KUBE_APP_HOME" ]; then
      echo:err "The KUBE_APP_HOME environment variable is mandatory and was not found"
      echo:err "Add it in your bashrc or OS environment variables"
      return 1
  fi
}

# @description test the connection to the cluster
kube::test_connection(){

  if OUTPUT=$(kubectl cluster-info); then
    return 0;
  fi
  echo::err "No connection could be made with the cluster"

  if [ -z "$KUBECONFIG" ]; then
      echo::err "Note: No KUBECONFIG env found"
  else
    if [ ! -f "$KUBECONFIG" ]; then
      echo::err "The KUBECONFIG env file ($KUBECONFIG) does not exist"
    else
      echo::info "The file ($KUBECONFIG) may have bad cluster info"
      echo::err "Note: The config is:"
      kubectl config view
      echo::err "We got the following output"
      echo::err "$OUTPUT"
    fi
  fi
  return 1

}


# @description
#   Set the env for the app and test the connection
kube::set_app_env_up(){

  if bash::is_interactive; then
    echo::err "This function should be called only non-interactively"
    return 1;
  fi

  APP_DIR=$(kube::get_app_dir "$APP_NAME")

  # Go to the app dir and pop at err and exit
  pushd "$APP_DIR" || return 1
  bash::trap 'popd' EXIT # EXIT execute also on error

  # Load the env
  ENV_LOADED=1
  if command::exists "direnv"; then
      # Direnv should be explicitly called in non-interactive mode
      # https://github.com/direnv/direnv/issues/262
      eval "$(direnv export bash)"
      ENV_LOADED=0
  fi

  if [ "$ENV_LOADED" = 1 ]; then
    echo::warn "Direnv not found on path"
    ENVRC_FILE="$APP_DIR/.envrc"
    if [ -f "$ENVRC_FILE" ]; then
      # shellcheck disable=SC1090
      source "$ENVRC_FILE"
    else
      echo::warn "File $ENVRC_FILE not found"
    fi
  fi

  # We test the connection because otherwise the user
  # may get a message that a resource could not be found
  # where the culprit should have been the connection
  kube::test_connection

}

# @description
#   Get the app name from the env in order
#   * from the env `$KUBE_APP_NAME`
#   * from the current working directory. If we are below the KUBE_APP_HOME directory
kube::get_app_name_from_env(){
  APP_NAME=${KUBE_APP_NAME:-}
  if [ "$APP_NAME" != "" ]; then
    echo::info "App name '$APP_NAME' determined by the KUBE_APP_NAME env."
    echo "$APP_NAME";
    return;
  fi
  kube::check_app_home
  if APP_NAME=$(path::relative_to "$PWD" "$KUBE_APP_HOME"); then
    echo::info "App name '$APP_NAME' determined because we are in the app directory."
    echo "$APP_NAME";
    return;
  fi
  return 1
}