#!/bin/bash

# Function to perform curl requests
perform_curl() {
    local url="$1"

    echo "Executing: curl $url"
    timeout 8 curl "$url"
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "

    echo "Executing: curl -i $url"
    timeout 8 curl -i "$url"
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "

    echo "Executing: curl -X OPTIONS $url"
    timeout 8 curl -X OPTIONS "$url"
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "

    echo "Executing: curl -X OPTIONS -i $url"
    timeout 8 curl -X OPTIONS -i "$url"
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "

    echo "Executing: curl -X GET -i $url"
    timeout 8 curl -X GET -i "$url"
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "

    echo "Executing: curl -X POST -i $url"
    response=$(timeout 8 curl -X POST -i "$url")
    echo "$response"
    if [[ "$response" == *"Length Required"* ]]; then
        echo "Executing: curl -X POST -I $url -H 'Content-Length: 0'"
        timeout 8 curl -X POST -i "$url" -H 'Content-Length: 0'
    fi
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "

    echo "Executing: curl -X PUT -i $url"
    response=$(timeout 8 curl -X PUT -i "$url")
    echo "$response"
    if [[ "$response" == *"Length Required"* ]]; then
        echo "Executing: curl -X PUT -I $url -H 'Content-Length: 0'"
        timeout 8 curl -X PUT -i "$url" -H 'Content-Length: 0'
    fi
    if [ $? -ne 0 ]; then
        echo "NO RESPONSE"
    fi
    echo " "
	echo "==========END============"
	echo " "
}

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <website.lst | URL>"
    exit 1
fi

# If the argument is a file, process each line as a URL
if [ -f "$1" ]; then
    while IFS= read -r url; do
        perform_curl "$url"
    done < "$1"
else
    perform_curl "$1"
fi
