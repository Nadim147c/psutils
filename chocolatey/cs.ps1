$query = $args -join ' ';


if (-not $query) {
    Write-Host "No argument has been provided" -ForegroundColor Red
    return
}

if (-not (CheckBinary choco chocolatey "winget install chocolatey")) {
    return
}

Write-Host("Searching for `"$args`"");
choco search "$query"

