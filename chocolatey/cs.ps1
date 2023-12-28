$query = $args -join ' ';
Write-Host("Searching for `"$args`"");
choco search "$query"

