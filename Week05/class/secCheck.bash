#!/bin/bash

# script to perform local security checks

function checks() {
	if [[ $2 != $3 ]]
	then
	
		echo -e "\e[1;31mThe $1 is not compliant. The current policy should be: $2, the current value is: $3.\e[0m"
		echo "remediation: $4"

	else

		echo -e "\e[1;32mThe $1 is Compliant. Current value $3.\e[0m"

	fi
}

#Check the password max days policy
pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ') 

# Check for password max
checks "Password Max Days" "365" "${pmax}"

#Check the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')

checks "password min days" "14" "${pmin}"

# Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "password warn age" "7" "${pwarn}"

# check the SSH UsePam config
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 }' )
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

# Check permissions on users home directory
echo ""
for eachDir in $( ls -l /home | egrep '^d' | awk ' { print $3 } ')
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ')
	checks "Home directory ${eachDir}" "drwx------" "${chDir}"
done

# check IP forwarding is disabled
secondChkIPForward=$(grep "net\.ipv4\.ip_forward" /etc/sysctl.conf /etc/sysctl.d/* | awk -F "=" ' {print $2} ')
checks "ip forwarding" "0" "${secondChkIPForward}" "Set the following parameter in /etc/sysctl.conf or/etc/sysctl.d/* net.ipv4.ip_forward = 0, then run the following commands to set the active kernel parameters: # sysctl -w net.ipv4.ip forward=0 # sysctl -w net.ipv4.route.flush=1" | less

#check ICMP redirects
checkICMPredirs=$(sysctl net.ipv4.conf.all.accept_redirects | awk -F "=" ' { print $2 } ')
rem="""
Remediation:
Set the following parameters in /etc/sysctl.conf or a /etc/sysctl.d/* file:
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
Run the following commands to set the active kernel parameters:
# sysctl -w net.ipv4.conf.all.accept_redirects=0
# sysctl -w net.ipv4.conf.default.accept_redirects=0
# sysctl -w net.ipv4.route.flush=1

CIS Controls:
Version 6
3 Secure Configurations
"""
checks "ICMP redirects" "0" "${checkICMPredirs}" "${rem}" | less

# Checks crontab permissions are acceptable
uidCheck=$(stat /etc/crontab | grep "id:" | awk -F "(" ' {print $3} ' | tr -d ' )Gid:' )
gidCheck=$(stat /etc/crontab | grep "id:" | awk -F "(" ' {print $4} ' | tr -d ' )' )
finalCheck="0/root"
#compares ids to make sure everything checks out
if [[ ${uidCheck} != ${gidCheck} || ${uidCheck} != ${finalCheck} ]]
then 
	finalCheck="insecure value"
fi
rem="""
Remediation:
Run the following commands to set ownership and permissions on /etc/crontab:
# chown root:root /etc/crontab
# chmod og-rwx /etc/crontab
"""
checks "crontab configs" "0/root" "${finalCheck}" "${rem}" |less

# checks that cron.hourly is correctly configured
uidCheck=$(stat /etc/cron.hourly | grep "id:" | awk -F "(" ' {print $3} ' | tr -d ' )Gid:' )
gidCheck=$(stat /etc/cron.hourly | grep "id:" | awk -F "(" ' {print $4} ' | tr -d ' )' )
finalCheck="0/root"
#compares ids to make sure everything checks out
if [[ ${uidCheck} != ${gidCheck} || ${uidCheck} != ${finalCheck} ]]
then
	        finalCheck="insecure value"
fi
rem="""
Remediation:
Run the following commands to set ownership and permissions on /etc/cron.hourly :
# chown root:root /etc/cron.hourly
# chmod og-rwx /etc/cron.hourly
"""
checks "cron.hourly configs" "0/root" "${finalCheck}" "${rem}" | less

# cron.daily
uidCheck=$(stat /etc/cron.daily | grep "id:" | awk -F "(" ' {print $3} ' | tr -d ' )Gid:' )
gidCheck=$(stat /etc/cron.daily | grep "id:" | awk -F "(" ' {print $4} ' | tr -d ' )' )
finalCheck="0/root"
#compares ids to make sure everything checks out
if [[ ${uidCheck} != ${gidCheck} || ${uidCheck} != ${finalCheck} ]]
then
	        finalCheck="insecure value"
fi
rem="""
Run the following commands to set ownership and permissions on /etc/cron.daily:
# chown root:root /etc/cron.daily
# chmod og-rwx /etc/cron.daily
"""
checks "cron.daily configs" "0/root" "${finalCheck}" "${rem}" | less

# cron.weekly
uidCheck=$(stat /etc/cron.weekly | grep "id:" | awk -F "(" ' {print $3} ' | tr -d ' )Gid:' )
gidCheck=$(stat /etc/cron.weekly | grep "id:" | awk -F "(" ' {print $4} ' | tr -d ' )' )
finalCheck="0/root"
#compares ids to make sure everything checks out
if [[ ${uidCheck} != ${gidCheck} || ${uidCheck} != ${finalCheck} ]]
then
	        finalCheck="insecure value"
fi
rem="""
Remediation:
Run the following commands to set ownership and permissions on /etc/cron.weekly:
# chown root:root /etc/cron.weekly
# chmod og-rwx /etc/cron.weekly
"""
checks "cron.weekly configs" "0/root" "${finalCheck}" "${rem}" | less

uidCheck=$(stat /etc/cron.monthly | grep "id:" | awk -F "(" ' {print $3} ' | tr -d ' )Gid:' )
gidCheck=$(stat /etc/cron.monthly | grep "id:" | awk -F "(" ' {print $4} ' | tr -d ' )' )
finalCheck="0/root"
#compares ids to make sure everything checks out
if [[ ${uidCheck} != ${gidCheck} || ${uidCheck} != ${finalCheck} ]]
then
	        finalCheck="insecure value"
fi
rem="""
Remediation:
Run the following commands to set ownership and permissions on /etc/cron.monthly:
# chown root:root /etc/cron.monthly
# chmod og-rwx /etc/cron.monthly
"""
checks "cron.monthly configs" "0/root" "${finalCheck}" "${rem}" | less


# ensure permissions on etc/passwd

remainingDirs=("passwd" "shadow" "group" "gshadow" "passwd-" "shadow-" "group-" "gshadow-")
# foor loop to parse the remaining directories and apply the same checks to them
for eachDir in ${remainingDirs[@]}
do

uidCheck=$(stat /etc/${eachDir} | grep "id:" | awk -F "(" ' {print $3} ' | tr -d ' )Gid:' )
gidCheck=$(stat /etc/${eachDir} | grep "id:" | awk -F "(" ' {print $4} ' | tr -d ' )' )
finalCheck="0/root"
#compares ids to make sure everything checks out
if [[ ${uidCheck} != ${gidCheck} || ${uidCheck} != ${finalCheck} ]]
then
	                finalCheck="insecure value"
fi
rem="""
Remediation:
Run the following commands to set ownership and permissions on /etc/${eachdir}:
# chown root:root /etc/${eachDir}
# chmod og-rwx /etc/${eachDir}
"""
checks "/etc/${eachDir} configs" "0/root" "${finalCheck}" "${rem}" |less
done

#For loop to check for legacy '+' entries
newDirList=("/etc/passwd" "/etc/shadow" "/etc/group")

for eachDir in ${newDirList[@]}
do
	checkLegacy=$(grep '^\+:' ${eachDir})
	rem="""
	Remove any legacy '+' entries from ${eachDir} if they exist.
	"""

	checks "Legacy '+' entries, don't worry these values should be blank, if they aren't something is wrong." "" "${checkLegacy}" "${rem}" | less
done

#check to make sure root is the only UID of 0
rootUIDCheck=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }')
rem="""
remove any users other than root with UID of 0 or assign them a new UID if appropriate
"""
checks "UIDs" "root" "${rootUIDCheck}" "${rem}"
