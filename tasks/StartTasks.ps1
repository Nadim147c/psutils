$taskList = Get-Content $Home\startlist.txt | Select-String exe

foreach ($task in $tasklist) {
    $path, $argument = $task.ToString().Split(",")
    Write-Host "Starting: $path" -ForegroundColor Green
    if ($argument) {
        Start-Process $path -ArgumentList $argument
    } else {
        Start-Process $path
    }
}

