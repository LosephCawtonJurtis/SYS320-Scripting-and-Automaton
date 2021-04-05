#story line: view the event logs check for a valid log and print the results

function select_log() {

    cls
    
    #list all event logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host

    #initialize the array to store the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {
    
        # Add each log to the array
        # NOTE: These are stored in the array as a hashtable in the format:
        # @{Log=LOGNAME}
        $arrLog += $TempLog

    }

    #prompt for log or quit
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"
    
    #check if the user wants to quit
    if ($readLog -match "^[qQ]$"){
        #exit out of the program
        break
    }

    log_check -logToSearch $readLog
}

function log_check() {

# arguments passed to the function
Param([string]$logToSearch)

#format input
$theLog = "^@{Log=" + $logToSearch + "}$"

#search the array for the exact hashtable string
if ($arrLog -match  $theLog){

    Write-Host -BackgroundColor Green -ForegroundColor white "please wait, it may take a few moments to retrieve the log entries."
    sleep 2

    #function call
    view_log -logToSearch $logToSearch

} else {

    Write-Host -BackgroundColor red -ForegroundColor white "the log specified doesn't exist"

    sleep 2

    select_Log
}

} # ends the log_check()

function view_log() {

    cls

    # string the user types in within the logcheck function
    #Param([string]$logToSearch)

    #get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -After "1/18/2020"

    #pause the screen and wait until the user is ready to proceed.
    read-host -Prompt "Press enter to continue"

    #go back to select_log
    select_Log
    


}

# run the select_log as the first function
select_Log


