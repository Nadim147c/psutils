param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$File,
    [Parameter(Position = 1, Mandatory = $true)]
    [string]$RarFile,
    [Parameter(Position = 2, Mandatory = $true)]
    [string]$Key
)

$arguments = "a", "-hp$Key", $RarFile, $File

Start-Process -FilePath "C:\Program Files\WinRAR\rar.exe" -ArgumentList $arguments -NoNewWindow -Wait
