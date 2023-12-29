$query = $args -join ' ';

if (-not (CheckBinary choco chocolatey "winget install chocolatey")) {
    return
}

if (-not (CheckBinary sudo "Gsudo" "winget install gerardog.gsudo")) {
    return
}

Write-Host("Searching for `"$args`"");
sudo choco install "$query"

