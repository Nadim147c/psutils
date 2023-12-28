param(
    [string]$path
)

if (-not $path) {
    $path = Get-Clipboard
}

Write-Output $path >> $Home\stoplist.txt
Write-Output $path >> $Home\startlist.txt
