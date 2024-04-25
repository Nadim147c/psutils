$role = [Security.Principal.WindowsBuiltInRole]::Administrator
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole($role)

if (-not $admin) {
    Write-Host "Requesting administrative privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit 1
}

$currentDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
Set-Location $currentDirectory

$bannedDir = @(".git")

Get-ChildItem | Foreach-Object {
    $isDirectory = Test-Path $_.Name -PathType Container
    $isAllowed = -not $bannedDir.Contains($_.Name)

    if ($isAllowed -and  $isDirectory) {
        $paths = [Environment]::GetEnvironmentVariable('PATH', 'Machine') -split ';'

        $path = Join-Path $currentDirectory $_.Name

        if (-not ($paths | Where-Object { $_ -eq $path })) {
            $newPath = [system.environment]::getenvironmentvariable('PATH', 'Machine') + ';' + $path
            [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')
            Write-Host "Directory added to PATH: $path"
        } else {
            Write-Host "Directory is already in PATH: $path"
        }
    } else {
        Write-Host "Skipped directory $($_.Name)"
    }
}
