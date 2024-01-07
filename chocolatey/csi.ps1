
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

function idToName ([string]$id) {
    $parts = [regex]::Split($id, "-|\.") 
    $name = ""
    $parts.ForEach({ $name = $name + " " + $_.Substring(0,1).ToUpper() + $_.Substring(1).ToLower() })

    return $name.Trim()
}

Write-Host("Searching for `"$args`"");

$items = choco search $query | Select-String "Approved"

$ids = @()

$i = 0

foreach ($item in $items) {
    $item = $item.ToString()

    $id = $item.Split(" ")[0].Trim()
    $name = idToName($id)
    $version = $item.Split(" ")[1].Trim()
    $ids = $ids + $id
    Write-Host "$($i + 1). $name" -NoNewline  
    Write-Host " [$version] " -NoNewline -ForegroundColor Green
    Write-Host "($id)" -ForegroundColor DarkGray 

    $i++
}

$index = Read-Host "`nWhich package you want to install"

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

Write-Host "`nInstalling $selectedId"
sudo choco install $selectedId -y
