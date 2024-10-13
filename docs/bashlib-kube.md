# bashlib-kube

A library of kubernetes functions

## Overview

A library of kubernetes functions

## Index

* [kube::get_app_label](#kubeget_app_label)
* [kube::get_resources_by_app_name](#kubeget_resources_by_app_name)
* [kube::get_resource_by_app_name](#kubeget_resource_by_app_name)

### kube::get_app_label

Return the app label used to locate resources
It will return the label `app.kubernetes.io/name=<app name>`
This is the common app label as seen on the [common label page](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

#### Example

```bash
APP_LABEL="$(kube::get_app_label "$APP_NAME")"
```

#### Arguments

* **$1** (string): The app name

#### Output on stdout

* The app label ie `app.kubernetes.io/name=<app name>`

### kube::get_resources_by_app_name

Function to search for resources across all namespaces by app name

#### Example

```bash
PODS="$(kube::get_resources_by_app_name "$APP_NAME" pod)"
```

#### Arguments

* **$1** (string): The app name
* **$2** (string): The resource type (pod, ...)

#### Output on stdout

* The resources name and namespace (one resource by line) or an empty string

### kube::get_resource_by_app_name

Function to search for 1 resource across all namespaces by app name

#### Example

```bash
read -r POD_NAME POD_NAMESPACE <<< "$(kube::get_resource_by_app_name "$APP_NAME" pod)"
if [ -z "$POD_NAME" ]; then
    echo "Error: Pod not found with label $(kube::get_app_label $APP_NAME)"
    exit 1
fi
```

#### Arguments

* **$1** (string): The app name
* **$2** (string): The resource type (pod, ...)

#### Exit codes

* **1**: - if too many resource was found

#### Output on stdout

* The resource name and namespace separated by a space or an empty string

