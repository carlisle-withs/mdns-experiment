# Run as Administrator. Adds inbound rules for Flask (TCP 5000) and mDNS (UDP 5353),
# restricted to the local subnet only.
$log = Join-Path $PSScriptRoot 'firewall_result.txt'
"--- $(Get-Date) ---" | Out-File $log -Encoding utf8

netsh advfirewall firewall add rule name="Flask 5000 TCP" dir=in action=allow protocol=TCP localport=5000 remoteip=localsubnet 2>&1 | Out-File $log -Append -Encoding utf8
netsh advfirewall firewall add rule name="mDNS 5353 UDP" dir=in action=allow protocol=UDP localport=5353 remoteip=localsubnet 2>&1 | Out-File $log -Append -Encoding utf8

"--- done ---" | Out-File $log -Append -Encoding utf8
Write-Output "Done. Details in firewall_result.txt"
