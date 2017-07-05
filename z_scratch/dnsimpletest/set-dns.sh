#!/bin/bash

DOMAIN=""
SUBDOMAIN=""
SERVICE_NAME=""

function show_usage(){
    echo "set-dns"
    echo
    echo -e "\t--domain\tSpecify the domain (e.g. example.com)"
    echo -e "\t--subdomain\tSpecify the subdomain to configure (e.g. mysubdomain)"
    echo -e "\t--service-name\tSpecify the service name in kubernetes"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --domain)
            DOMAIN="$2"
            shift 2
            ;;
        --subdomain)
            SUBDOMAIN="$2"
            shift 2
            ;;
        --service-name)
            SERVICE_NAME="$2"
            shift 2
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

if [ -z $DOMAIN ]; then
    echo "domain not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $SUBDOMAIN ]; then
    echo "subdomain not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $SERVICE_NAME ]; then
    echo "service name not specified"
    echo
    show_usage
    exit 1
fi

while [ 1 -eq 1 ]; do
    ipAddress=$(kubectl get service $SERVICE_NAME -o json | jq -r '.status.loadBalancer.ingress[0].ip')

    echo $ipAddress
    if [[ $ipAddress == "null" ]]; then
        # no record yet - nothing to do
        echo "waiting..."
    else
        # existing record - delete it
        echo "Found IP Address: $ipAddress. Setting DNS for $SUBDOMAIN.$DOMAIN"
        ./set-a-record.sh --zone $DOMAIN --name $SUBDOMAIN --ip $ipAddress
        exit 0
    fi

    sleep 5s
done
