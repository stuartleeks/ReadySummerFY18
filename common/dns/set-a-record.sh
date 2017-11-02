#!/bin/bash

# expects the following env vars to be set: AZDNS_RESOURCE_GROUP

DOMAIN=""
SUBDOMAIN=""
IP=""

function show_usage(){
    echo "set-a-record"
    echo
    echo -e "\t--domain\tSpecify the domain name"
    echo -e "\t--subdomain\tSpecify the subdomain"
    echo -e "\t--ip\tSpecify the ip address"
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
        --ip)
            IP="$2"
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

if [ -z $IP ]; then
    echo "ip address not specified"
    echo
    show_usage
    exit 1
fi

if [ -z $AZDNS_RESOURCE_GROUP ]; then
    echo "AZDNS_RESOURCE_GROUP variable not set"
    exit 1
fi

current_ip_address=$(az network dns record-set  a show --resource-group $AZDNS_RESOURCE_GROUP --zone-name $DOMAIN --name $SUBDOMAIN --query "arecords[0].ipv4Address" --output tsv)

if [[ $current_ip_address == $IP ]]; then
    # no record yet - create one
    echo "Record already set to correct value"
else
    if [[ $current_ip_address == "" ]]; then
        # no record yet - create one
        echo "creating $SUBDOMAIN.$DOMAIN..."
        az network dns record-set a create --resource-group $AZDNS_RESOURCE_GROUP --zone-name $DOMAIN --name $SUBDOMAIN --ttl 60 > null
        echo "setting IP address..."
        az network dns record-set a add-record --resource-group $AZDNS_RESOURCE_GROUP --zone-name $DOMAIN --record-set-name $SUBDOMAIN --ipv4-address $IP > null
    else
        # existing record - update it
        echo "updating $SUBDOMAIN.$DOMAIN..."
        az network dns record-set a update --resource-group $AZDNS_RESOURCE_GROUP --zone-name $DOMAIN --name $SUBDOMAIN --set arecords[0].ipv4Address=$IP > null
    fi
fi

