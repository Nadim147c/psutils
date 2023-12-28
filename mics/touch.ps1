param(
    [string]$path
)

if ($MyInvocation.ExpectingInput -and -not $path) {
    $path = $input 
}

if (-not $path) {
    Write-Host "Please provide a file path"
    Write-Host "dog [file_path]"
    return
}

if (-not (Test-Path -Path $path)) {
    New-Item -ItemType File -Path $path -Force 
} else {
    Write-Output "File already exists" 
}
