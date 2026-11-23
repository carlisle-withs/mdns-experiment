$ErrorActionPreference = 'Stop'
$profile = [Windows.Networking.Connectivity.NetworkInformation,Windows.Networking.Connectivity,ContentType=WindowsRuntime]::GetInternetConnectionProfile()
$mgr = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager,Windows.Foundation,ContentType=WindowsRuntime]::CreateFromConnectionProfile($profile)

if ("$($mgr.TetheringOperationalState)" -eq 'On') {
    $op = $mgr.StopTetheringAsync()
    while ("$($op.Status)" -eq 'Started') { Start-Sleep -Milliseconds 200 }
    Start-Sleep -Seconds 2
    Write-Output "Hotspot stopped"
}
$op2 = $mgr.StartTetheringAsync()
while ("$($op2.Status)" -eq 'Started') { Start-Sleep -Milliseconds 200 }
Start-Sleep -Seconds 1
Write-Output "Hotspot state after restart: $($mgr.TetheringOperationalState)"
