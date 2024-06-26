$query = $args -join ' ';

if (-not $query) {
    Write-Host "No argument has been provided" -ForegroundColor Red
    return
}

if (-not (CheckBinary fzf fzf "winget install junegunn.fzf")) {
    return
}

Write-Host("Searching for `"$args`"");

$result = winget search $query

$idAndVersionLengthFinder = $result | Select-String "Name *Id *Version"

if (-not $idAndVersionLengthFinder) {
    Write-Host "0 result found"
    return 
}

if ($idAndVersionLengthFinder.GetType().BaseType.Name -eq "Array") {
    $idAndVersionLengthFinder = $idAndVersionLengthFinder[0]
}

$idLength = $idAndVersionLengthFinder.ToString().Split("Id")[0].Length

$items = $result | Select-String "winget|msstore" 

if ($items.Length -eq 0) {
    Write-Host "0 result found"
    return 
}

$ids = @()

foreach ($item in $items) {
    $item = $item.ToString()

    $name = $item.Substring(0, $idLength).Trim()
    if ($name.Contains("ΓÇ") -or $name.Length -ge $idLength) {
        continue 
    }

    $id = $item.Substring($idLength).Split(" ")[0].Trim()
    $ids = $ids + $id
}

$selectedId =  $ids | fzf --info inline-right --layout reverse --preview 'winget show --id {}' --preview-label "Package Information"

if (-not $selectedId) {
    return Write-Host "Command exited without input" -ForegroundColor Red 
}

Write-Host "`nInstalling $selectedId" -ForegroundColor Green
winget install --id $selectedId
