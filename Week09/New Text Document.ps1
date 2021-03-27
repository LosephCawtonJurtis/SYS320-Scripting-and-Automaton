# Storyline: Using the Get-Process and Get-Service
#Get-Process |Select-Object ProcessName, Path, ID | `
#Export-Csv -Path "A:\School\Classes\sys320\PSdirectory\SYS320-Scripting-and-Automaton\Week09\myProcesses.csv"
#Get-Process | Get-Member
Get-Service | Where { $_.Status -eq "Stopped" }
