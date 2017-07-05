#!/bin/bash

# expects the following env vars to be set: DNSIMPLE_TOKEN, DNSIMPLE_ACCOUNT

ZONE=""
NAME=""
IP=""

function show_usage(){
    echo "set-a-record"
    echo
    echo -e "\t--zone | -z\tSpecify the zone (e.g. example.com)"
    echo -e "\t--name | -n\tSpecify the name (e.g. mysubdomain)"
    echo -e "\t--ip | -i\tSpecify the ip address"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --zone | -z)
            ZONE="$2"
            shift 2
            ;;
        --name | -n)
            NAME="$2"
            shift 2
            ;;
        --ip | -i)
            IP="$2"
            shift 2
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
done

if [ -z $ZONE ]; then
    echo "zone not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $NAME ]; then
    echo "name not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $IP ]; then
    echo "ip address not specified"
    echo
    show_usage
    exit 1
fi

record_id=$(curl -s   -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
        -H 'Accept: application/json' \
        "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records?name=$NAME" \
        | jq '.data[0].id')

if [[ $record_id == "null" ]]; then
    # no record yet - create one
    echo "creating..."
    curl    -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/json' \
            -X POST \
            -d '{ "name": "'$NAME'", "type": "A", "content": "'$IP'", "ttl": 60 }' \
            "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records"
else
    # existing record - update it
    echo "updating $record_id..."
    curl    -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/json' \
            -X PATCH \
            -d '{ "content": "'$IP'" }' \
            "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records/$record_id"
fi

