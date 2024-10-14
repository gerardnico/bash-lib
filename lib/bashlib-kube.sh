# @name bashlib-kube
# @brief A library of kubernetes functions
# @description
#     A library of kubernetes functions
#
#

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
# @arg $1 string The app name
# @arg $2 string The resource type (pod, ...)
# @example
#    PODS="$(kube::get_resources_by_app_name "$APP_NAME" pod)"
#
# @stdout The resources name and namespace (one resource by line) or an empty string
kube::get_resources_by_app_name() {
  local APP_NAME=$1
  local RESOURCE_TYPE=$1

  APP_LABEL=$(kube::get_app_label "$APP_NAME")
  #
  # With customs columns, it works also. Example:
  #     kubectl get pod -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace --no-headers -l "$APP_LABEL" -A
  #
  kubectl get "$RESOURCE_TYPE" --all-namespaces -l "$APP_LABEL" -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.namespace}{"\n"}{end}' 2>/dev/null

}

# @description
#     Function to search for 1 resource across all namespaces by app name
# @arg $1 string The app name
# @arg $2 string The resource type (pod, ...)
# @example
#    read -r POD_NAME POD_NAMESPACE <<< "$(kube::get_resource_by_app_name "$APP_NAME" pod)"
#    if [ -z "$POD_NAME" ]; then
#        echo "Error: Pod not found with label $(kube::get_app_label $APP_NAME)"
#        exit 1
#    fi
#
# @stdout The resource name and namespace separated by a space or an empty string
# @exitcode 1 - if too many resource was found
kube::get_resource_by_app_name(){
  local APP_NAME=$1
  local RESOURCE_TYPE=$2
  RESOURCES="$(kube::get_resources_by_app_name "$APP_NAME" "$RESOURCE_TYPE")"
  RESOURCE_COUNT=$(echo "$RESOURCES" | sed '/^\s*$/d' | wc -l )
  if [ "$RESOURCE_COUNT" -gt 1 ]; then
      echo "Error: Multiple $RESOURCE_TYPE found with the label app.kubernetes.io/name=$APP_NAME:"
      echo "$RESOURCES"
      exit 1
  fi;
  echo "$RESOURCES"
}
