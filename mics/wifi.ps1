param(
    [string]$Name
)

if (-not (CheckBinary "qr" "qrcode" "pip install qrcode")) {
    return
}

if ($Name) {
    $profileinfo = netsh wlan show profile name="$Name" key=clear
    $ssids =  $profileinfo | Select-String  "Name" | ForEach-Object { $_.tostring().split(":")[1].trim() }
    $password = $profileinfo | Select-String "key content" | ForEach-Object { $_.tostring().split(":")[1].trim() }


    if ($ssids.GetType().BaseType.Name -eq "Array") {
        $Name = $ssids[0]
    } elseif ($ssids.GetType().Name -eq "String") {
        $Name = $ssids
    }

    Write-Host "ssid: $name"
    Write-Host "password: $password"
	
    # pip install qrcode
    qr --error-correction=H "WIFI:T:WPA;S:$name;P:$password;;"
    return
}

$profiles = netsh wlan show profiles

$networks = $profiles | Select-String "All User Profile" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }

if ($networks.Count -eq 0) {
    return Write-Host "No WiFi networks found." -ForegroundColor Yellow
}

if ($networks.GetType().Name -eq "String") {
    return wifi $networks
}

$network = $networks | fzf

if ( $network) {
    return wifi $network
}

Write-Host "Command exited without input" -ForegroundColor Red

