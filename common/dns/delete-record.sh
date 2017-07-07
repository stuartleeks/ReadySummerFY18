#!/bin/bash

# expects the following env vars to be set: DNSIMPLE_TOKEN, DNSIMPLE_ACCOUNT

DOMAIN=""
SUBDOMAIN=""

function show_usage(){
    echo "set-a-record"
    echo
    echo -e "\t--domain\tSpecify the domain name"
    echo -e "\t--subdomain\tSpecify the subdomain"
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

record_id=$(curl -s   -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
        -H 'Accept: application/json' \
        "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$DOMAIN/records?name=$SUBDOMAIN" \
        | jq '.data[0].id')

if [[ $record_id == "null" ]]; then
    # no record yet - nothing to do
    echo "not found"
else
    # existing record - delete it
    echo "deleting $record_id..."
    curl    -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/json' \
            -X DELETE \
            "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$DOMAIN/records/$record_id"
fi

