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
checks "ip forwarding" "0" "${secondChkIPForward}" "Set the following parameter in /etc/sysctl.conf or/etc/sysctl.d/* net.ipv4.ip_forward = 0, then run the following commands to set the active kernel parameters: # sysctl -w net.ipv4.ip forward=0 # sysctl -w net.ipv4.route.flush=1"

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
checks "ICMP redirects" "0" "${checkICMPredirs}" "${rem}"
