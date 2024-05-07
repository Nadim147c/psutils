param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$path,
    [Parameter(Position = 1)]
    [string]$destination
)

if (-not $destination) {
    $destination = [System.IO.Path]::Combine((Get-Location).Path, [System.IO.Path]::GetFileNameWithoutExtension($path) + ".zip")
}
Compress-Archive -Path $path -DestinationPath $destination
