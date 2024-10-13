# bashlib-kube

A library of kubernetes functions

## Overview

A library of kubernetes functions

## Index

* [kube::get_pod_by_app_name](#kubeget_pod_by_app_name)

### kube::get_pod_by_app_name

Returns the pod name and namespace from an app name

#### Example

```bash
read -r POD_NAME POD_NAMESPACE <<< "$(kube::get_pod_by_app_name "$APP_NAME")"
```

#### Arguments

* **$1** (string): The app name

#### Exit codes

* **1**: if no pod was not found

#### Output on stdout

* The pod name and namespace

