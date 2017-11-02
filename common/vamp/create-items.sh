#!/bin/bash

BASE_URL="http://vamp.azure.faux.ninja:8080"
DEPLOYMENT_FILE=""

function show_usage(){
    echo "create-items"
    echo
    echo -e "\t--base-url\t(Optional) Specify the base vamp url [default $BASE_URL]"
    echo -e "\t--deployment-file | -f\tThe file containing the items to deploy"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --base-url)
            BASE_URL="$2"
            shift 2
            ;;
        --deployment-file | -f)
            DEPLOYMENT_FILE="$2"
            shift 2
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

if [ -z $DEPLOYMENT_FILE ]; then
    echo "deployment file not specified"
    echo
    show_usage
    exit 1
fi


# Deployment file should be
# ---
# kind: breed
# name: name-here
# ...
#
# ---
# kind: <next kind>
# ...

# see vamp runner recipes for examples

curl    -X PUT \
        -H 'Content-Type: application/x-yaml' \
        -H 'Accept: application/x-yaml' \
        --data-binary @$DEPLOYMENT_FILE \
        "$BASE_URL/api/v1/"