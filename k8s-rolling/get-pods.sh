#!/bin/bash
blue="\e[1;34m"
green="\e[1;32m"
no_colour="\e[1;0m"

# kubectl get pod -l run=rolling -o json | jq -r '.items | .[] | [.metadata.name, .spec.containers[0].image, (.status.containerStatuses[0].state | keys | .[])] | @tsv' 

IFS=$'\n'
for pod in $(kubectl get pod -l run=rolling -o json | jq -r '.items | .[] | [.metadata.name, .spec.containers[0].image, (.status.containerStatuses[0].state | keys | .[])] | @tsv' )
do
    colour=$(echo $pod | grep -Po "(?<=:)(?:[a-z]*)")
    ansiColour=${!colour}
    echo -e "$ansiColour$pod$no_colour"
done
