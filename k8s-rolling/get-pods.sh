#!/bin/bash

kubectl get pod -l run=rolling -o json | jq -r '.items | .[] | [.metadata.name, .spec.containers[0].image, (.status.containerStatuses[0].state | keys | .[])] | @tsv' 