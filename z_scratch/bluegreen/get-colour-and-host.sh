#!/bin/bash

# update the URL

url=http://13.79.164.72/

blue="\e[1;34m"
green="\e[1;32m"

while [ 1 -eq 1 ]; do
    curl $url -s -o /tmp/bluegreen.html

    colour=$( grep -Po "(?<=background-color: )(?:[a-z0-9-]*)(?=;)"  /tmp/bluegreen.html)
    host=$(grep -Po "(?<=>)(?:[a-z0-9-]*)(?=</body)"  /tmp/bluegreen.html)

    ansiColour=${!colour}
    echo -e "${ansiColour}Host: $host   Colour: $colour"
    # sleep 0.1
done

## TODO
#
#  - make the url a parameter