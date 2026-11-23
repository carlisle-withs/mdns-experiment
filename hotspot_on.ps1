$ErrorActionPreference = 'Stop'
$profile = [Windows.Networking.Connectivity.NetworkInformation,Windows.Networking.Connectivity,ContentType=WindowsRuntime]::GetInternetConnectionProfile()
if (-not $profile) { throw "No internet connection profile found" }
$mgr = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager,Windows.Foundation,ContentType=WindowsRuntime]::CreateFromConnectionProfile($profile)

Write-Output "Current hotspot state: $($mgr.TetheringOperationalState)"
$config = $mgr.GetCurrentAccessPointConfiguration()
Write-Output "Hotspot SSID: $($config.SSID)"
Write-Output "Hotspot password: $($config.Passphrase)"

if ("$($mgr.TetheringOperationalState)" -ne 'On') {
    $op = $mgr.StartTetheringAsync()
    while ("$($op.Status)" -eq 'Started') { Start-Sleep -Milliseconds 200 }
    Write-Output "Start call result: $($op.Status)"
    Write-Output "Hotspot state after start: $($mgr.TetheringOperationalState)"
}
