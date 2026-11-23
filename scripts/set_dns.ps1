param(
    [Parameter(Mandatory = $true)][string]$Address,
    [string]$Adapter = "WLAN"
)

# Usage (run as Administrator):
#   .\set_dns.ps1 -Address 127.0.0.1   # point adapter DNS at local DNS server
#   .\set_dns.ps1 -Address dhcp        # restore DHCP-assigned DNS (rollback)

$log = Join-Path $PSScriptRoot 'dns_change_result.txt'
"--- $(Get-Date) set DNS on '$Adapter' -> $Address ---" | Out-File $log -Encoding utf8

if ($Address -eq 'dhcp') {
    netsh interface ip set dns name="$Adapter" source=dhcp 2>&1 | Out-File $log -Append -Encoding utf8
} else {
    netsh interface ip set dns name="$Adapter" source=static addr=$Address 2>&1 | Out-File $log -Append -Encoding utf8
}

netsh interface ip show dns name="$Adapter" | Out-File $log -Append -Encoding utf8
Write-Output "Done. Details in dns_change_result.txt"
