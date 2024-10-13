# @name bashlib-kube
# @brief A library of kubernetes functions
# @description
#     A library of kubernetes functions
#
#


# @description
#     Returns the pod name and namespace from an app name
# @arg $1 string The app name
# @exitcode 1 if no pod was not found
# @example
#    read -r POD_NAME POD_NAMESPACE <<< "$(kube::get_pod_by_app_name "$APP_NAME")"
#
# @stdout The pod name and namespace
kube::get_pod_by_app_name(){
  APP_LABEL="app.kubernetes.io/name=$APP_NAME"
  # the name label as seen here: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/
  # label app.kubernetes.io/name=prometheus
  POD_ID="$(kubectl get pod -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace --no-headers -l "$APP_LABEL" -A)"
  if [ -z "$POD_ID" ]; then
      echo::err "Error: Pod not found with label $APP_LABEL"
      return 1
  fi
  echo "$POD_ID"
}