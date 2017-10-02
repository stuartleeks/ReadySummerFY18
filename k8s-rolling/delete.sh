#!/bin/bash

SCRIPT=$(readlink -f $0)
BASE_DIR=`dirname ${SCRIPT}`

kubectl delete -f "$BASE_DIR/definitions/rolling.yml"
