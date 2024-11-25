#!/bin/bash

# Ensure correct number of arguments
if [[ "$#" -ne 5 ]]; then
    echo "Usage: bash $0 <file.txt> <protocol> <username> <password> <domain>"
    echo "example: protocol = smb / ftp / rdp"
    echo "example: domain = corp.com"
    exit 1
fi


# Assign arguments to variables
file=$1
protocol=$2
Username=$3
Password=$4
Domain=$5

# Validate file existence
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Read file into an array
mapfile -t ips < "$file"

# Iterate over the array using a for loop
for ip in "${ips[@]}"; do
    # Skip empty lines
    [[ -z "$ip" ]] && continue
    echo "Running command for IP: $ip"
    crackmapexec "$protocol" "$ip" -u "$Username" -p "$Password" -d "$Domain" --continue-on-success
done

echo " "
echo "if you see (Pwn3d!), it means there its a local admin"
