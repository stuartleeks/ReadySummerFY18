#!/bin/bash

# expects the following env vars to be set: DNSIMPLE_TOKEN, DNSIMPLE_ACCOUNT

ZONE=faux.ninja
NAME=apitest
IP=52.169.226.141

# curl    -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
#         -H 'Accept: application/json' \
#         "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records"

# curl    -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
#         -H 'Accept: application/json' \
#         -H 'Content-Type: application/json' \
#         -X POST \
#         -d '{ "name": "apitest", "type": "A", "content": "52.169.226.141", "ttl": 60 }' \ # TODO - parameterise NAME!!
#         "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records"



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

