$query = $args -join ' ';
Write-Host("Searching for `"$args`"");
sudo choco install "$query"

