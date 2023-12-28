$admin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $admin) {
    Write-Host "Requesting administrative privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit 0
}

Set-Location ..
$currentDirectory = Get-Location

# Check if the directory is already in the PATH
$paths = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';'
if (-not ($paths | Where-Object { $_ -eq $currentDirectory })) {
    # Add the current directory to the PATH
    $newPath = [system.environment]::getenvironmentvariable('path', 'machine') + ';' + $currentDirectory
    [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')
    Write-Host "Directory added to PATH: $currentDirectory"
} else {
    Write-Host "Directory is already in PATH: $currentDirectory"
}
