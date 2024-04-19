if (-not $MyInvocation.ExpectingInput) {
    return Write-Host "No input provided" -ForegroundColor Red
}

$input | ForEach-Object { Invoke-Expression "$args $_"}
