# storyline: Review the Security Event Log

# List all the availabvle windows event logs
Get-EventLog -list

# Create a prompt to allow user to select the Log to view

$readLog = Read-host -Prompt "Please select a log to review from the list above."

$readSearch = Read-Host -Prompt "include a term to search the log for."


# print the results of the log
Get-EventLog $readLog -Newest 40 | where {$_.Message -ilike "*$readSearch*" } | Export-Csv -NoTypeInformation `
-Path "A:\School\Classes\sys320\PSdirectory\SYS320-Scripting-and-Automaton\Week08\securityLogs.csv"
