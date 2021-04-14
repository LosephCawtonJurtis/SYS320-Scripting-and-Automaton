

function displayOptions() {
    cls
    $readService = read-host -prompt "select 'all', 'running', or 'stopped' services or type 'q' to quit"

    if ($readService -match "^[qQ]$"){
        #exit out of the program
        write-host "exiting"
        break
    }

    foreach ($tempOpt in $arrOptions){
  
        if($readService -match $tempOpt -and $tempOpt -eq "all"){
        Get-Service
        read-host -prompt "press enter to continue"
        displayOptions
        }
        elseif ($readService -match $tempOpt -and $tempOpt -eq "running"){
        Get-Service | Where-Object {$_.Status -EQ "$tempOpt"}
        read-host -prompt "press enter to continue"
        displayOptions
        }
        elseif ($readService -match $tempOpt -and $tempOpt -eq "stopped"){
        Get-Service | Where-Object {$_.Status -EQ "$tempOpt"}
        read-host -prompt "press enter to continue"
        displayOptions
        }
        elseif ($readService -ne "all" -and $readService -ne "running" -and $readService -ne "stopped" ) {
        Write-Host "you're input was not correct, try again"
        sleep 2
        displayOptions
        }
    }
    
}

# run the select_Services as the first function
cls

Get-Service

read-host -Prompt "press enter to continue"

$arrOptions = @('all', 'running', 'stopped')

displayOptions


