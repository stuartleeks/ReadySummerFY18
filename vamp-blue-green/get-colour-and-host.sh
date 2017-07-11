#!/bin/bash

# update the URL

url=http://bluegreen.faux.ninja/

blue="\e[1;34m"
green="\e[1;32m"
no_colour="\e[1;0m"

while [ 1 -eq 1 ]; do
    curl $url -s -o /tmp/bluegreen.html

    colour=$( grep -Po "(?<=background-color: )(?:[a-z0-9-]*)(?=;)"  /tmp/bluegreen.html)
    host=$(grep -Po "(?<=>)(?:[a-z0-9-]*)(?=</body)"  /tmp/bluegreen.html)

    ansiColour=${!colour}
    echo -e "$ansiColourHost: $host   Colour: $colour$no_colour"
    sleep 0.5
done

## TODO
#
#  - make the url a parameter
