param(
    [string]$path
)

if ($MyInvocation.ExpectingInput -and -not $path) {
    $path = $input 
}

if (-not $path) {
    Write-Host "Path argument is missing." -ForegroundColor Red
    Write-Host "dog [file_path]"
}

pygmentize -g -O style=colorful $path
