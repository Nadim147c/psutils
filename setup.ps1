$role = [Security.Principal.WindowsBuiltInRole]::Administrator
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole($role)

if (-not $admin) {
    Write-Host "Requesting administrative privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit 0
}

$currentDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
Set-Location $currentDirectory

$folders = @(
    "chocolatey",
    "ffmpeg",
    "ImageMagick"
    "mics",
    "tasks",
    "winget",
    "yt-dlp",
    "zip"
)

Get-ChildItem | Foreach-Object {
    if ($folders.Contains($_.Name)) {
        $paths = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';'

        $path = Join-Path $currentDirectory $_.Name

        if (-not ($paths | Where-Object { $_ -eq $path })) {
            $newPath = [system.environment]::getenvironmentvariable('path', 'machine') + ';' + $path
            [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')
            Write-Host "Directory added to PATH: $path"
        } else {
            Write-Host "Directory is already in PATH: $path"
        }
    } else {
        Write-Host "Skipped directory $($_.Name)"
    }
}
