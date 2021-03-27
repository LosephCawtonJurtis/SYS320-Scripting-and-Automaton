Get-Process | Select-Object ProcessName, Path, ID | Export-Csv processes.csv
get-Service | where { $_.Status -eq "running" } | Export-Csv services.csv