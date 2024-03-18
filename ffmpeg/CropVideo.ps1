param(
    [Parameter(position = 0, Mandatory = $true)]
    [string]$InputPath,
    [Parameter(position = 1, Mandatory = $false)]
    [int]$RatioWidth,
    [Parameter(position = 2, Mandatory = $false)]
    [int]$RatioHeight,
    [Parameter(position = 3, Mandatory = $false)]
    [string]$OutputPath,
    [int]$Top = 0,
    [int]$Bottom = 0,
    [int]$Left = 0,
    [int]$Right = 0,
    [ValidateSet("white", "black")]
    [string]$BarColor = "black",
    [int]$Time = 2,
    [switch]$Preview
)

if (-not (CheckBinary ffmpeg ffmpeg "winget install Gyan.FFmpeg`" or `"choco install ffmpeg")) {
    return
}

if (-not (CheckBinary sed sed "choco install sed")) {
    return
}

$videoSize = ffprobe -v error -select_streams "v:0" -show_entries stream="width,height" -of "csv=s=x:p=0" $InputPath

$videoWidth = [int]($videoSize.ToString().Split("x")[0])
$videoHeight = [int]($videoSize.ToString().Split("x")[1])

if ($RatioWidth -and $RatioHeight) {

    $wr = $videoWidth / $RatioWidth
    $hr = $videoHeight / $RatioHeight

    $width = ($wr, $hr | Measure-Object -Minimum).Minimum * $RatioWidth
    $height = ($width / $RatioWidth) * $RatioHeight

    $x = ($videoWidth - $width) / 2
    $y = ($videoHeight - $height) / 2

    $crop = "$($width):$($height):$($x):$($y)"
} else {
    if ($BarColor -eq "black") {
        $cropValues = ffmpeg -i $InputPath -t $Time -vf "eq=contrast=1.8,cropdetect" -f null - 2>&1 | sed -n '1!G;h;$p' | Select-String '(?<=crop=).*?(?=$)' 
    } else {
        $cropValues = ffmpeg -i $InputPath -t $Time -vf "eq=contrast=1.8,negate,cropdetect" -f null - 2>&1 | sed -n '1!G;h;$p' | Select-String '(?<=crop=).*?(?=$)' 
    }

    $crop = $cropValues | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value} | Sort-Object | Get-Unique

    $cropSplit = $crop.Split(":")

    $width = [int]$cropSplit[0] + $Left + $Right
    $height = [int]$cropSplit[1] + $Top + $Bottom
    $x = [int]$cropSplit[2] - $Left
    $y = [int]$cropSplit[3] - $Top 

    if ($x + $width -gt $videoWidth) {
        $width = $videoWidth - $x
    }

    if ($y + $height -gt $videoHeight) {
        $height = $videoHeight - $y
    }

    $crop = "$($width):$($height):$($x):$($y)"
}


if (-not $OutputPath) {
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
    $extension = [System.IO.Path]::GetExtension($InputPath)

    $OutputPath = "$fileName.crop$($width)x$height$extension"
}


if ($Preview) {
    Write-Host "Running:"
    Write-Host "ffplay -i '$InputPath' -vf 'crop=$crop,scale=450:-1'" -ForegroundColor Cyan
    ffplay -i $InputPath -vf "crop=$crop,scale=450:-1"
} else {
    Write-Host "Running:"
    Write-Host "ffmpeg -i '$InputPath' -vf 'crop=$crop' -c copy $OutputPath\n" -ForegroundColor Cyan

    ffmpeg -i $InputPath -vf "crop=$crop" -c copy $OutputPath

    Write-Host "Rerun (with fixes) this command to fix mistakes: "
    Write-Host "ffmpeg -i '$InputPath' -y -vf 'crop=$crop' -c copy $OutputPath" -ForegroundColor Cyan
}

