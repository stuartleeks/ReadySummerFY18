#!/bin/bash
blue="\e[1;34m"
green="\e[1;32m"
no_colour="\e[1;0m"

REFRESH=false

function show_usage(){
    echo "get-pods"
    echo
    echo -e "\t--refresh\tkeep querying and re-displaying"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --refresh)
            REFRESH=refresh
            shift 1
            ;;
        *)
            echo "Unexpected '$1'"
            show_usage
            exit 1
            ;;
    esac
done

function dump_pods(){
    # $1 is clear to clear screen

    IFS=$'\n'
    lines=$(kubectl get pod -l run=rolling -o json | jq -r '.items | .[] | [.metadata.name, .spec.containers[0].image, (.status.containerStatuses[0].state | keys | .[])] | @tsv' )
    if [ "$1" == clear ]; then
        clear
    fi
    for pod in $lines
    do
        colour=$(echo $pod | grep -Po "(?<=:)(?:[a-z]*)")
        ansiColour=${!colour}
        echo -e "$ansiColour$pod$no_colour"
    done

    # IFS=$'\n'
    # for pod in $(kubectl get pod -l run=rolling -o json | jq -r '.items | .[] | [.metadata.name, .spec.containers[0].image, (.status.containerStatuses[0].state | keys | .[])] | @tsv' )
    # do
    #     colour=$(echo $pod | grep -Po "(?<=:)(?:[a-z]*)")
    #     ansiColour=${!colour}
    #     echo -e "$ansiColour$pod$no_colour"
    # done
}


if [ "$REFRESH" == refresh ]; then
    while [ 1 -eq 1 ]; do
        dump_pods clear
        sleep 0.5s
    done
else
    dump_pods
fi