# Story line: get network adapter information and output it 

#Get-WmiObject -class Win32_service | select Name, PathName, ProcessId
#Get-WmiObject -class Win32_service | where { $_.Name -ilike "win32_c*" } | Sort-Object
#Get-WmiObject -Class Win32_Account | Get-Member
#Get-WmiObject -Class Win32_wlanSvc
#Get-WmiObject -class Win32_net
Get-WmiObject -class Win32_NetworkAdapterConfiguration | Select DHCPServer, IPAddress, DefaultIPGateway, DNSServer |`
Export-Csv networkinfo.csv
