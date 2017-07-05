#!/bin/bash
ZONE=faux.ninja
NAME=apitest
IP=52.169.226.141

record_id=$(curl -s   -H "Authorization: Bearer $DNSIMPLE_TOKEN" \
        -H 'Accept: application/json' \
        "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records?name=$NAME" \
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
            "https://api.dnsimple.com/v2/$DNSIMPLE_ACCOUNT/zones/$ZONE/records/$record_id"
fi

