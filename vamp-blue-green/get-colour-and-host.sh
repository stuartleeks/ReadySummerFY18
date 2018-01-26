#!/bin/bash

# update the URL

url=http://bluegreen.$READY_DOMAIN_NAME/

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
            echo "using cookie jar..."
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
            echo "using cookie jar..."
        curl $url -i -s -b /tmp/bluegreencookies.txt --cookie-jar /tmp/bluegreencookies.txt -o /tmp/bluegreen.html
    else
        curl $url -i -s -o /tmp/bluegreen.html
    fi

    status=$(grep -Po "(?<=HTTP/1.[01] )(?:[0-9]*)" /tmp/bluegreen.html)
    if [ "$status" == "200" ]; then
        colour=$(grep -Po "(?<=background-color: )(?:[a-z0-9-]*)(?=;)"  /tmp/bluegreen.html)
        host=$(grep -Po "(?<=>)(?:[a-z0-9-]*)(?=</body)"  /tmp/bluegreen.html)

        ansiColour=${!colour}
        echo -e "${ansiColour}Host: $host   Colour: $colour$no_colour"
    else
        message=$(grep -Po "(?<=<h1>)(?:.*)(?=</h1>)" /tmp/bluegreen.html )
        echo -e "$red$message$no_colour"
    fi
    sleep 0.5
done

## TODO
#
#  - make the url a parameter
