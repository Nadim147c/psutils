param(
    [Parameter(position = 0, Mandatory = $true)]
    [string]$InputPath,
    [Parameter(position = 1, Mandatory = $true)]
    [int]$RatioWidth,
    [Parameter(position = 2, Mandatory = $true)]
    [int]$RatioHeight,
    [Parameter(position = 3, Mandatory = $false)]
    [string]$OutputPath
)

if (-not (CheckBinary magick ImageMagick "winget install --id ImageMagick.ImageMagick")) {
    return
}

if (-not (CheckBinary identify "ImageMagick/Identify" "winget install --id ImageMagick.ImageMagick")) {
    return
}

$imageWidth = identify -format "%w" $InputPath
$imageHeight = identify -format "%h" $InputPath

$wr = $imageWidth / $RatioWidth
$hr = $imageHeight / $RatioHeight

$width = ($wr, $hr | Measure-Object -Minimum).Minimum * $RatioWidth
$height = ($width / $RatioWidth) * $RatioHeight

$x = ($imageWidth - $width) / 2
$y = ($imageHeight - $height) / 2

if (-not $OutputPath) {
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
    $extenstion = [System.IO.Path]::GetExtension($InputPath)
    $OutputPath = "$filename.crop$($width)x$($height)$extenstion"
}

$crop = "$($width)x$height+$x+$y"

magick $InputPath -crop $crop $OutputPath
