# Description

Tells Tilt to ignore logs from specified containers

# Usage
```
# to ignore the container named 'sidecar' in the 'doggos' resource:
local_resource('ignore_doggos_sidecar', serve_cmd='./ignore-containers.sh doggos sidecar')
```
