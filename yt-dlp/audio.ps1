param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Url,
    [string]$Sections = "",
    [string]$CookiesFile,
    [switch]$UseBraveCookies,
    [switch]$NoSponserBlock,
)

if (-not (CheckBinary "yt-dlp" "yt-dlp" "pip install yt-dlp")) {
    return
}

if (-not (CheckBinary "ffmpeg" "ffmpeg" "winget install Gyan.FFmpeg`" or `"choco install ffmpeg")) {
    return
}

$outputPath = "%USERPROFILE%\Downloads\Audio\%(title)s-%(id)s.%(ext)s"

$arguments = @(
    "--extract-audio",
    "--format", "ba/best",
    "--audio-format", "mp3",
    "-o", $outputPath,
    "--no-playlist",
    "--audio-quality", "0",
    "--add-metadata",
    "--embed-thumbnail",
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

$validUrl = [System.Uri]::TryCreate($Url, [System.UriKind]::Absolute, [ref]$null)

if (-not $validUrl) {
    $Url = "ytsearch:`"$Url`""
} else {
    $arguments = $arguments + "-x"
}

Write-Host("Running:")
Write-Host("yt-dlp $($arguments -join " ") $Url") -ForegroundColor Cyan 

yt-dlp $arguments $Url
