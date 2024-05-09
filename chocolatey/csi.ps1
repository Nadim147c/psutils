
$query = $args -join ' ';

if (-not $query) {
    Write-Host "No argument has been provided" -ForegroundColor Red
    return
}

if (-not (CheckBinary choco chocolatey "winget install chocolatey")) {
    return
}

if (-not (CheckBinary sudo "Gsudo" "winget install gerardog.gsudo")) {
    return
}

if (-not (CheckBinary fzf fzf "sudo choco install fzf")) {
    return
}

Write-Host("Searching for `"$args`"");

$items = choco search $query | Select-String "Approved" | ForEach-Object { $_.ToString().Split(" ")[0] }

$fzfOutput = $items | fzf --info inline-right --layout reverse --preview 'choco info {}' --preview-label "Package Information"

if (-not $fzfOutput) {
    return Write-Host "Command exited without input" -ForegroundColor Red
}
$id = $fzfOutput.Split(" ")[0]


Write-Host "`nInstalling $id"
sudo choco install $id -y
