param(
[string]$Name
)

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

Write-Host "Available WiFi Networks: $($networks.Count)"
for ($i = 0; $i -lt $networks.Count; $i++) {
    Write-Host "$($i + 1). $($networks[$i])"
}

$choice = [int](Read-Host "Enter the number of the network you want to share")

if ($choice -ge 1 -and $choice -le $networks.Count) {
    return wifi $networks[$choice - 1]
} else {
    Write-Host "Invalid selection. Please choose a valid option." -ForegroundColor Red
}
