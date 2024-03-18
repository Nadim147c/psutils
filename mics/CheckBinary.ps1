param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Command,
    [Parameter(Position = 1, Mandatory = $true)]
    [string]$CommandName,
    [Parameter(Position = 2, Mandatory = $true)]
    [string]$InstallCommand
)

$oldPreference = $ErrorActionPreference
$ErrorActionPreference = ‘stop’

try {
    $cmdExists = Get-Command $Command
    if ($cmdExists) { return $true }   
} catch {
    Write-Host "$CommandName isn't installed in your system." -ForegroundColor Red
    Write-Host "Run: `"" -NoNewline
    Write-Host $InstallCommand -NoNewline -ForegroundColor Cyan
    Write-Host "`" to install $CommandName."
    return $false
} Finally {
    $ErrorActionPreference = $oldPreference
}
