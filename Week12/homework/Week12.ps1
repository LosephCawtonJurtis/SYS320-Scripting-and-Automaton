# Storyline: Collect data in response to incident


function RecordPath() {

cls

$targetDir = read-host -Prompt "Please enter the directory to save the files or enter q to quit"

# Check if location exists
    if (Test-Path $targetDir) {

    echo "gathering data, can be found at the entered directory"

    # running processes 
    $RPList = $targetDir + "\RunningProcess.csv"
    Get-Process | Select-Object Path | Export-Csv -Path $RPList


    # Running Services
    $RSList = $targetDir + "\RunningService.csv"
    Get-WmiObject -List | Select-Object Path | Export-Csv -Path $RSList


    # TCP Sockets
    $TCPSList = $targetDir + "\TCPSLists.csv"
    Get-NetTCPConnection | Export-Csv -Path $TCPSList


    # Account Info
    $userinfo = $targetDir + "\UserInfo.csv"
    Get-WmiObject -Class Win32_UserAccount | Export-Csv -Path $userinfo


    # NetAd config info
    $netConfig = $targetDir + "\NetConfig.csv"
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path $netConfig


    # Get System event logs
    # Logs are a quick way to gain a general idea of what was going on on the system at the time of the incident and can be easily sorted with scripts.
    $sysLogs = $targetDir + "\SystemLog.csv"
    Get-EventLog -Log System -Newest 25 | Export-Csv -Path $sysLogs

    # Get Security event logs
    # This just gathers a larger data set to search through allowing for a more indepth look
    $secLogs = $targetDir + "\SecurityLog.csv"
    Get-EventLog -Log Security -Newest 25 | Export-Csv -Path $secLogs

    # Get Application event logs
    # Again furthering the data set. But additionally if I'm only grabbing a small number of things it makes sense to have all those types of data
    # be the same, as in logs so that the code required to sort through them doesn't have to be altered per data set
    $getApp = $targetDir + "\ApplicationLog.csv"
    Get-EventLog -Log Application -Newest 25 | Export-Csv -Path $getApp

    # Get Firewall rules
    # Firewall rules can make it easy to figure out how the issue got through or could also have kept information about the incident itself
    $getFWRules = $targetDir + "\FirewallRules.csv"
    Get-NetFirewallRule | Export-Csv -Path $getFWRules


    # Create checksum file and save it to the directory

    $Checksum = $targetDir + "\Checkums.csv"
    Get-FileHash -Path $RPList | select Hash, Path | Export-Csv $Checksum
    Get-FileHash -Path $RSList | Export-Csv -Append $Checksum
    Get-FileHash -Path $TCPSList | Export-Csv -Append $Checksum
    Get-FileHash -Path $userinfo | Export-Csv -Append $Checksum
    Get-FileHash -Path $netconfig | Export-Csv -Append $Checksum
    Get-FileHash -Path $getSystem | Export-Csv -Append $Checksum
    Get-FileHash -Path $getsecurity | Export-Csv -Append $Checksum
    Get-FileHash -Path $getApp | Export-Csv -Append $Checksum
    Get-FileHash -Path $getFirewall | Export-Csv -Append $Checksum

    # Compress directory and create checksum

    Compress-Archive -Path "$targetDir" -DestinationPath "$targetDir"
    Get-FileHash -Path "C:\Users\joseph.lawtoncurtis\Desktop\Homework\week11output.zip" | select Hash, Path | Export-Csv -Path "C:\Users\joseph.lawtoncurtis\Desktop\Homework\week11output\CSData.csv"

    #Doesn't seem correct but I'm not deleting it for reference
    #Send-PowerShellServerFile -Server youreerver -AuthMode password -User joseph.lawtoncurtis -Password -RemoteFile "C:\Users\joseph.lawtoncurtis\Desktop\Homework\week11output.zip" -LocalFile C:

    New-SSHSession -ComputerName '192.168.4.50' -Credential (Get-Credential joseph.lawtoncurtis@cyber.local)

    Set-SCPFile -ComputerName "192.168.4.50" -Credential (Get-Credential joseph.lawtoncurtis@cyber.local) -RemotePath "/home/joseph.lawtoncurtis@cyber.local" -LocalFile "C:\Users\joseph.lawtoncurtis\Desktop\Homework\week11output.zip"
    
    if ((Invoke-SSHCommand -index 0 'ls | grep week11').Output -eq "week11output.zip") {

        echo "File sent successfully" 

        } else {

        echo "The file was not sent successfully"

        }

        # Close down session
        Remove-SSHSession -SessionId 0

    } 

    elseif ($targetDir -eq "q" -or $targetDir -eq "Q") {
    exit
    }

    else {

    read-host -Prompt "file path does not exist, press enter to continue or q to quit"
    RecordPath

    }

}

RecordPath

