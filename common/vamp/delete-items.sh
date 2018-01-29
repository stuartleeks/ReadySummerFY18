#!/bin/bash

BASE_URL="http://vamp.$DEMO_DOMAIN_NAME:8080"
DEPLOYMENT_FILE=""

function show_usage(){
    echo "delete-items"
    echo
    echo -e "\t--base-url\t(Optional) Specify the base vamp url [default $BASE_URL]"
    echo -e "\t--deployment-file | -f\tThe file containing the items to delete"
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

# substitute env vars in yaml file before sending to VAMP
envsubst < $DEPLOYMENT_FILE  > tmp/deploy.yml

curl    -X DELETE \
        -H 'Content-Type: application/x-yaml' \
        -H 'Accept: application/x-yaml' \
        --data-binary @tmp/deploy.yml \
        "$BASE_URL/api/v1/"