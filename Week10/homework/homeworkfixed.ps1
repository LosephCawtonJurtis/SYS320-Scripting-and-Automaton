$arrOptions = @('all', 'running', 'stopped')
 $readService = read-host -prompt "select 'all', 'running', or 'stopped' services or type 'q' to quit"

    if ($readService -match "^[qQ]$"){
        #exit out of the program
        write-host "exiting"
        break
    }

function displayOptions() {
    cls

    foreach ($tempOpt in $arrOptions){
    
    #Write-Host $readService
    #Write-Host $tempOpt
  
        if($readService -match $tempOpt -and $tempOpt -eq "all"){
        Get-Service
        read-host -prompt "press enter to continue"
        displayOptions
        }
        elseif ($readService -match $tempOpt){

        Get-Service | Where-Object {$_.Status -EQ "$tempOpt"}
        read-host -prompt "press enter to continue"
        displayOptions
        }
        elseif ($tempOpt -eq "stopped"){
        Write-Host "you're input was not correct, try again"
        read-host -prompt "press enter to continue"
        displayOptions
        }
    
    }

    read-host -prompt "press enter to continue"
    #displayOptions
}

# run the select_Services as the first function
cls

Get-Service

read-host -Prompt "press enter to continue"

displayOptions

