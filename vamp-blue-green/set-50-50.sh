#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

"$BASE_DIR/../common/vamp/create-items.sh" -f "$BASE_DIR/definitions/gateway-50-50.yml"
