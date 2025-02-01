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
    if [[ -n "$grep_exclude" ]]; then
        curl -s "$full_url" | grep -v "$grep_exclude"
    else
        curl -s "$full_url"
    fi
done < "$payload_list"

