$taskList = Get-Content $Home\stoplist.txt | Select-String exe

foreach ($task in $tasklist) {
    $path = $task.ToString().Split(",")[0]
    $taskName = [System.IO.Path]::GetFileName($path)
    Write-Host "Stopping: $taskName" -ForegroundColor Red
    taskkill /IM $taskName /F
}
