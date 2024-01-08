param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$InputPath,
    [Parameter(Position = 1, Mandatory = $false)]
    [string]$OutputPath,
    [ValidateSet("ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow")]
    [string]$Preset = "medium"
)

if (-not $OutputPath) {
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
    $OutputPath = "$fileName.HEVC.mkv"
}

ffmpeg -i $InputPath -c:v libx265 -preset $Preset $OutputPath 
