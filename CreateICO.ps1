param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$inputPath,
    [Parameter(Position = 1, Mandatory = $true)]
    [string]$outputPath
)

magick $inputPath -resize 16x16 -depth 32 16.png
magick $inputPath -resize 24x24 -depth 32 24.png
magick $inputPath -resize 32x32 -depth 32 32.png
magick $inputPath -resize 48x48 -depth 32 48.png
magick $inputPath -resize 128X128 -depth 32 128.png
magick $inputPath -resize 256x256 -depth 32 256.png

magick 16.png 24.png 32.png 48.png 128.png 256.png $outputPath

Remove-Item 16.png
Remove-Item 24.png
Remove-Item 32.png
Remove-Item 48.png
Remove-Item 128.png
Remove-Item 256.png
