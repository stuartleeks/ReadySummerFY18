#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

DOMAIN=""
SUBDOMAIN=""
GATEWAY_NAME=""

function show_usage(){
    echo "set-dns"
    echo
    echo -e "\t--domain\tSpecify the domain (e.g. example.com)"
    echo -e "\t--subdomain\tSpecify the subdomain to configure (e.g. mysubdomain)"
    echo -e "\t--gateway-name\tSpecify the gateway name (Note sava/9050 becomes sava_9050)"
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
        --gateway-name)
            GATEWAY_NAME="$2"
            shift 2
            ;;
        *)
            echo "Unexpected '$1'"
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

if [ -z $GATEWAY_NAME ]; then
    echo "gateway name not specified"
    echo
    show_usage
    exit 1
fi

while [ 1 -eq 1 ]; do
    ipAddress=$(kubectl get service -l io.vamp.gateway=$GATEWAY_NAME -o json | jq -r '.items[0].status.loadBalancer.ingress[0].ip')

    if [[ $ipAddress == "null" ]]; then
        # no record yet - nothing to do
        echo "waiting..."
    else
        # existing record - delete it
        echo "Found IP Address: $ipAddress. Setting DNS for $SUBDOMAIN.$DOMAIN"
        $BASE_DIR/../common/dns/set-a-record.sh --domain $DOMAIN --subdomain $SUBDOMAIN --ip $ipAddress
        echo
        exit 0
    fi

    sleep 5s
done
