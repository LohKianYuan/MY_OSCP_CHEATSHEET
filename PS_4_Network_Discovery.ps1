# Get the IP address from ipconfig output
$ipConfig = ipconfig | Out-String

# Define regex patterns for private IP ranges
$privateIPPatterns = @(
    '(10\.\d{1,3}\.\d{1,3}\.)',
    '(172\.\d{1,3}\.\d{1,3}\.)'
)

# Initialize an empty list to hold active hosts
$activeHosts = @()

# Extract subnet base and check for matches
foreach ($pattern in $privateIPPatterns) {
    if ($ipConfig -match $pattern) {
        $subnetBase = $matches[1]

        Write-Host "Detected subnet base: $subnetBase"

        # Loop through IPs in the range .1 to .254
        foreach ($i in 1..254) {
            $ip = "$subnetBase$i"
            Write-Host "Checking $ip..."

            # Ping the host
            if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
                Write-Host "$ip is online" -ForegroundColor Green
                $activeHosts += $ip
            } else {
                Write-Host "$ip is offline" -ForegroundColor Red
            }
        }

        # Exit the loop if a match is found to avoid checking other patterns
        break
    }
}

# Output the list of active hosts
Write-Host "Active Hosts:" -ForegroundColor Cyan
$activeHosts
