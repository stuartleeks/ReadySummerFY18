#!/bin/bash

BASE_URL="http://vamp.$DEMO_DOMAIN_NAME:8080"
DEPLOYMENT_FILE=""

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

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

TEMP_DIR=$BASE_DIR/../../tmp
if [ ! -d "$TEMP_DIR" ]; then
    mkdir $TEMP_DIR
fi

# substitute env vars in yaml file before sending to VAMP
envsubst < $DEPLOYMENT_FILE  > $TEMP_DIR/deploy.yml


curl    -X PUT \
        -H 'Content-Type: application/x-yaml' \
        -H 'Accept: application/x-yaml' \
        --data-binary @$TEMP_DIR/deploy.yml \
        "$BASE_URL/api/v1/"