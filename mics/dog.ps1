param(
    [string]$path
)

if (-not (CheckBinary pygmentize Pygments "pip install pygments")) {
    return
}

if ($MyInvocation.ExpectingInput -and -not $path) {
    $path = $input 
}

if (-not $path) {
    Write-Host "Path argument is missing." -ForegroundColor Red
    Write-Host "dog [file_path]"
    return
}

pygmentize -g -O style=colorful $path
