param(
    [Parameter(position = 0, Mandatory = $true)]
    [string]$InputPath,
    [int]$Loop = 0
)

if (-not (CheckBinary "ffmpeg" "ffmpeg" "winget install Gyan.FFmpeg`" or `"choco install ffmpeg")) {
    return
}

$palette = "$(New-Guid).png"

$videoSize = ffprobe -v error -select_streams "v:0" -show_entries stream="width,height" -of "csv=s=x:p=0" $InputPath
$videoWidth = $videoSize.ToString().Split("x")[0]

ffmpeg -i $InputPath -vf palettegen $palette

$outputPath = "$([System.IO.Path]::GetFileNameWithoutExtension($InputPath)).gif"

$filter = "fps=10,scale=$($videoWidth):-1[x];[x][1:v]paletteuse"

ffmpeg -i $InputPath -i $palette -loop $Loop -filter_complex $filter $outputPath

Remove-Item $palette

