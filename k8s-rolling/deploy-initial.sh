#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

kubectl apply -f "$BASE_DIR/definitions/rolling.yml"

if [ ! -z $DEMO_DOMAIN_NAME ]; then
    echo "setting dns..."
    $BASE_DIR/../common/dns/set-dns.sh --domain $DEMO_DOMAIN_NAME --subdomain rolling --service-name rolling
fi