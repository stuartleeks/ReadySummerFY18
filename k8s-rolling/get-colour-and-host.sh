#!/bin/bash

# update the URL

url=http://rolling.$READY_DOMAIN_NAME/

blue="\e[1;34m"
green="\e[1;32m"
red="\e[1;31m"
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

rm -f /tmp/rollingcookies.txt

while [ 1 -eq 1 ]; do

    if [ "$COOKIES" == cookies ]; then
        curl $url -i -s -b /tmp/rollingcookies.txt --cookie-jar /tmp/rollingcookies.txt -o /tmp/rolling.html
    else
        curl $url -i -s -o /tmp/rolling.html
    fi

    status=$(grep -Po "(?<=HTTP/1.[01] )(?:[0-9]*)" /tmp/rolling.html)
    if [ "$status" == "200" ]; then
        colour=$(grep -Po "(?<=background-color: )(?:[a-z0-9-]*)(?=;)"  /tmp/rolling.html)
        host=$(grep -Po "(?<=>)(?:[a-z0-9-]*)(?=</body)"  /tmp/rolling.html)

        ansiColour=${!colour}
        echo -e "${ansiColour}Host: $host   Colour: $colour$no_colour"
    else
        message=$(grep -Po "(?<=<h1>)(?:.*)(?=</h1>)" /tmp/rolling.html )
        echo -e "$red$message$no_colour"
    fi
    # sleep 0.1
done

## TODO
#
#  - make the url a parameter
