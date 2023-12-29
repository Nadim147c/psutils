$query = $args -join ' ';

if (-not (CheckBinary choco chocolatey "winget install chocolatey")) {
    return
}

Write-Host("Searching for `"$args`"");
choco search "$query"

