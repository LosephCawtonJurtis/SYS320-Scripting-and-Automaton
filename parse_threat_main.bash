#!/bin/bash
# Storyline: Extract IPs from emerging threats.net and create a firewall ruleset

# Regex to extract the networks
#5.         134.         128.   0/    19

#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

#wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv


# Check if file exists
if [[ -f "emerging-drop.suricata.rules" ]]
then	
	echo "the file exists, should it be updated?"
	read -p "Y/n" choice

	if [[ $choice == "Y" || $choice == "y" ]]
	then
		wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules
	fi

fi

if [[ -f "targetedthreats.csv" ]]
then
        echo "the file exists, should it be updated?"
        read -p "Y/n" choice

        if [[ $choice == "Y" || $choice == "y" ]]
        then
                wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
        fi

fi

grep "domain" /tmp/targetedthreats.csv | cut -d, f2 | tee -a badDomains.txt

while getopts ':icmnwhp:' OPTION; do

	case "$OPTION" in
	
		i)
			for eachIP in $(cat badIPs.txt)
			do
				echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
			done

		;;
		c)
			for eachIP in $(cat badIPs.txt)
			do
				echo "access-list 1 deny ${eachIP}" | tee -a badIPsCisco.txt
			done

		;;
		m)
			for eachIP in $(cat badIPs.txt)
			do
				echo "block in from ${eachIP} to any" | tee -a pf.conf
			done
		;;
		n)
			for eachIP in $(cat badIPs.txt)
			do
				echo "set policy id 2 name \"Block bad IP \" from \" Trust \" to \" Untrust \" ${eachIP} \" ANY \" ANY \" deny" | tee -a badIPs.nscr
			done
		;;
		w)
			for eachIP in $(cat badIPs.txt)
			do
				echo "netsh advfirewall firewall add rule name="BLOCK IP ADDRESS - ${eachIP}" dir=in action=block remoteip=${eachIP}" | tee -a badIPswindows.txt

			done
		;;
		h) echo "Usage: $(basename $0) [-i/c/m/n/w/h]"
		;;
		p)
			#grep "domain" targetedthreats.csv | cut -d, f2
			
			echo "class-map match-any BAD_URLS" | tee -a badDomainsCisco.txt

			for eachDomain in $(cat badDomains.txt)
			do
				echo "match protocol http host ${eachDomain}" | tee -a badDomainsCisco.txt
			done
		;;
		*) echo "Invalid value"
		;;
	

	esac
done

# Create a firewall ruleset
#for eachIP in $(cat badIPs.txt)
#do
#	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

#done

