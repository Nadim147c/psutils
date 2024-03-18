# fuzzy Manual reader

if (-not (CheckBinary rg ripgrep "choco install ripgrep")) { return }

if (-not (CheckBinary fzf fzf "choco install fzf")) { return }

if (-not $MyInvocation.ExpectingInput) {
    return Write-Host "No input provided" -ForegroundColor Red
}

$inputData = @()

# Iterate over the input and store it in the variable
foreach ($line in $input) { $inputData += $line }

$search = $inputData | fzf

$inputData | rg -A 20 -F -p "$search"
