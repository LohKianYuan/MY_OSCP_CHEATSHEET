#!/bin/bash

# Usage message function
usage() {
    echo "Usage: $0 -u URL -p payload_list [-v grep_exclude]"
    exit 1
}

# Parse command-line arguments
while getopts "u:p:v:" opt; do
    case ${opt} in
        u) url=${OPTARG} ;;
        p) payload_list=${OPTARG} ;;
        v) grep_exclude=${OPTARG} ;;
        *) usage ;;
    esac
done

# Ensure required arguments are provided
if [[ -z "$url" || -z "$payload_list" ]]; then
    usage
fi

# Ensure the payload file exists
if [[ ! -f "$payload_list" ]]; then
    echo "Error: Payload list file not found!"
    exit 1
fi

# Extract base URL before '='
base_url="${url%%=*}="

# Loop through payloads and make requests
while IFS= read -r payload; do
    full_url="${base_url}${payload}"
    echo " " >> output.txt
    echo "Executing: curl -s \"$full_url\""
    echo "Payload: $payload"
    echo "Executing: curl -s \"$full_url\"" >> output.txt
    echo "Payload: $payload" >> output.txt
    echo " " >> output.txt
    if [[ -n "$grep_exclude" ]]; then
        curl -s "$full_url" | grep -v "$grep_exclude" >> output.txt
    else
        curl -s "$full_url" >> output.txt
    fi

    echo -e "\n===============================================================" >> output.txt
done < "$payload_list"
echo " " >> output.txt
echo " " >> output.txt
echo "All payloads processed. Output saved to output.txt"
