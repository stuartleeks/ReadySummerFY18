#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`


"$BASE_DIR/set-gateway-blue.sh"
"$BASE_DIR/../common/vamp/delete-items.sh" -f "$BASE_DIR/definitions/clean-green.yml"
