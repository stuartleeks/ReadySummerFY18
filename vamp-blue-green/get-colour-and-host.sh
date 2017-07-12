#!/bin/bash

# update the URL

url=http://bluegreen.faux.ninja/

blue="\e[1;34m"
green="\e[1;32m"
no_colour="\e[1;0m"


COOKIES=false

function show_usage(){
    echo "get-colour-and-host"
    echo
    echo -e "\t--cookies\tpreserve cookies across requests"
}

while [[ $# -gt 0 ]]
do
    case "$1" in 
        --cookies)
            COOKIES=cookies
            shift 1
            ;;
        *)
            echo "Unexpected '$1'"
            show_usage
            exit 1
            ;;
    esac
done

rm -f /tmp/bluegreencookies.txt

while [ 1 -eq 1 ]; do
    if [ "$COOKIES" == cookies ]; then
        curl $url -s -b /tmp/bluegreencookies.txt --cookie-jar /tmp/bluegreencookies.txt -o /tmp/bluegreen.html
    else
        curl $url -s -o /tmp/bluegreen.html
    fi

    colour=$( grep -Po "(?<=background-color: )(?:[a-z0-9-]*)(?=;)"  /tmp/bluegreen.html)
    host=$(grep -Po "(?<=>)(?:[a-z0-9-]*)(?=</body)"  /tmp/bluegreen.html)

    ansiColour=${!colour}
    echo -e "${ansiColour}Host: $host   Colour: $colour$no_colour"
    sleep 0.5
done

## TODO
#
#  - make the url a parameter
