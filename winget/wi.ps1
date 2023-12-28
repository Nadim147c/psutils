$query = $args -join ' ';

if (-not $query) {
    Write-Host "No argument has been provided" -ForegroundColor Red
    return
}

Write-Host("Searching for `"$args`"");

$result = winget search $query

$nameLengthFinder = $result | Select-String "Name *Id"

if ($nameLengthFinder.GetType().BaseType.Name -eq "Array") {
    $nameLengthFinder = $nameLengthFinder[0]
}

$idLength = $nameLengthFinder.ToString().Split("Id")[0].Length

$items = $result | Select-String "winget|msstore" 

if ($items.Length -eq 0) {
    Write-Host "0 result found"
    return 
}

$ids = @()

for ($i = 0; $i -lt $items.Count; $i++) {
    $item = $items[$i].ToString()
    $name = $item.Substring(0, $idLength).Trim()
    $id = $item.Substring($idLength).Split(" ")[0].Trim()
    $ids = $ids + $id
    Write-Host "$($i + 1). $name " -NoNewline  
    Write-Host "($id)" -ForegroundColor DarkGray 
}

$index = Read-Host "`nWrite the number of package you want to install"

if (-not $index) {
    Write-Host "Command exited without input" -ForegroundColor Red
    return
}

$selectedId = $ids[[int]$index - 1]

Write-Host "`nInstalling $selectedId"
winget install --id $selectedId
