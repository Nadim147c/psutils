$query = $args -join ' ';

if (-not $query) {
    Write-Host "No argument has been provided" -ForegroundColor Red
    return
}

Write-Host("Searching for `"$args`"");

$result = winget search $query

$idAndVersionLengthFinder = $result | Select-String "Name *Id *Version"

if ($idAndVersionLengthFinder.GetType().BaseType.Name -eq "Array") {
    $idAndVersionLengthFinder = $idAndVersionLengthFinder[0]
}


$idLength = $idAndVersionLengthFinder.ToString().Split("Id")[0].Length
$versionLength = $idAndVersionLengthFinder.ToString().Split("Version")[0].Length

$items = $result | Select-String "winget|msstore" 

if ($items.Length -eq 0) {
    Write-Host "0 result found"
    return 
}

$ids = @()

$i = 0

foreach ($item in $items) {
    $item = $item.ToString()

    $name = $item.Substring(0, $idLength).Trim()

    if ($name.Contains("ΓÇ")) {
        continue
    }

    $id = $item.Substring($idLength).Split(" ")[0].Trim()
    $version = $item.Substring($versionLength).Split(" ")[0].Trim()
    $ids = $ids + $id
    Write-Host "$($i + 1). $name" -NoNewline  
    Write-Host " [$version] " -NoNewline -ForegroundColor Green
    Write-Host "($id)" -ForegroundColor DarkGray 

    $i++
}

$index = Read-Host "`nWhich package you want to show"

if (-not $index) {
    Write-Host "Command exited without input" -ForegroundColor Red
    return
}

try {
    $index = [int]$index - 1
    if ($index -lt 0 -or $index -ge $ids.Count) {
        Write-Host "Number is out of limit" -ForegroundColor Red
        return
    }
} catch {
    Write-Host "Invalid number" -ForegroundColor Red
    return
}

$selectedId = $ids[$index]

Write-Host "`nShowing $selectedId"
winget show --id $selectedId
