param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$path,
    [Parameter(Position = 1)]
    [string]$destination
)

if ($destination -eq "") {
    $destination = [System.IO.Path]::Combine((Get-Location).Path, [System.IO.Path]::GetFileNameWithoutExtension($path))
}
Expand-Archive -Path $path -DestinationPath $destination
