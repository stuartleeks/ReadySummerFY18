#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

"$BASE_DIR/../common/vamp/create-items.sh" -f "$BASE_DIR/definitions/deploy-initial.yml"


if [ ! -z $DEMO_DOMAIN_NAME ]; then
    echo "setting dns..."
    $BASE_DIR/../vamp-blue-green/set-dns-for-gateway.sh --domain $DEMO_DOMAIN_NAME --subdomain bluegreen --gateway-name demo_80 
fi