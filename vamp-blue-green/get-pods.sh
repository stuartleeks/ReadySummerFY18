#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

blue="\e[1;34m"
green="\e[1;32m"
no_colour="\e[1;0m"

REFRESH=refresh

function show_usage(){
    echo "get-pods"
    echo
    echo -e "\t--no-refresh\tjust query once"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --no-refresh)
            REFRESH=false
            shift 1
            ;;
        *)
            echo "Unexpected '$1'"
            show_usage
            exit 1
            ;;
    esac
done

if [ "$REFRESH" == refresh ]; then
    watch --color --interval 0.5 $BASE_DIR/get-pods.sh --no-refresh
else
    lines=$(kubectl get pod -l "io.vamp.deployment in (demo-blue,demo-green)" -o json | jq -r '.items | .[] | [.metadata.name, .spec.containers[0].image, (.status.containerStatuses[0].state | keys | .[])] | @tsv' )
    IFS=$'\n'
    for pod in $lines
    do
        colour=$(echo $pod | grep -Po "(?<=:)(?:[a-z]*)")
        ansiColour=${!colour}
        echo -e "$ansiColour$pod$no_colour"
    done
fi