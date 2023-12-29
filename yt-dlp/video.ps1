param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Url,
    [string]$Sections = "",
    [ValidateSet("mp4", "webm", "mkv")]
    [string]$Format = "mp4",
    [string]$CookiesFile,
    [switch]$UseBraveCookies,
    [switch]$NoSponserBlock
)

if (-not (CheckBinary "yt-dlp" "yt-dlp" "pip install yt-dlp")) {
    return
}

if (-not (CheckBinary "ffmpeg" "ffmpeg" "winget install Gyan.FFmpeg`" or `"choco install ffmpeg")) {
    return
}

$outputPath = "%USERPROFILE%\Downloads\Video\%(title)s-%(id)s.%(ext)s"

$arguments = @(
    "-f", "bv[height<=1080]+ba/b",
    "--merge-output-format", $Format,
    "-o", $outputPath,
    "--add-metadata",
    "--embed-chapters",
    "--list-formats",
    "--no-simulate"
)

if ($Sections -ne "") {
    $arguments = $arguments + "--download-sections" + $Sections 
}

if ($CookiesFile) {
    $arguments = $arguments + "--cookies" + $CookiesFile 
}

if ($UseBraveCookies) {
    $arguments = $arguments + "--cookies-from-browser" + "brave" 
}

if (-not $NoSponserBlock) {
    $arguments = $arguments + "--sponsorblock-remove" + "all" 
}

$validUrl = [System.Uri]::TryCreate($url, [System.UriKind]::Absolute, [ref]$null)
if (-not $validUrl) {
    $url = "ytsearch:`"$Url`""
}

Write-Host("Running:")
Write-Host("yt-dlp $($arguments -join " ") $Url") -ForegroundColor Cyan

yt-dlp $arguments $Url
