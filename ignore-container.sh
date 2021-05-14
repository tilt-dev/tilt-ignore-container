#!/bin/bash

# Allows you to filter out noisy containers.
# To use this in Tilt:
# local_resource('ignore_doggos_sidecar', serve_cmd='./ignore-containers.sh doggos sidecar')

# This watches for new podlogstreams created by tilt and adds the specified container to the watch's ignore list.

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <resource-name> <container-name>"
  exit 1
fi

RESOURCE_NAME="$1"
CONTAINER_NAME="$2"

tilt get podlogstream -ojsonpath="{range .items[*]}{@}{'\n'}" --watch | while read -r pls; do
  ADD_IGNORE_CONTAINER="$(echo "$pls" | jq '.metadata.annotations["tilt.dev/resource"] == "'"$RESOURCE_NAME"'" and all(.spec.ignoreContainers[] != "'"$CONTAINER_NAME"'"; .)')"
  if [[ $ADD_IGNORE_CONTAINER == true ]]; then
    echo "$pls" | jq '.spec.ignoreContainers += ["'"$CONTAINER_NAME"'"] | del(.status)' | tilt apply -f -
  fi
done
