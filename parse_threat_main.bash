#!/bin/bash
# Storyline: Extract IPs from emerging threats.net and create a firewall ruleset

# Regex to extract the networks
#5.         134.         128.   0/    19

#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -o /tmp/emerging-drop.suricata.rules

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Check if file exists
if [[ -f "emerging-drop.suricata.rules" ]]
	
	echo "the file exists, should it be updated?"
	read -p "Y/n" choice

	if [[ $choice == "Y" || $choice == "y" ]]
	
		wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -o /tmp/emerging-drop.suricata.rules
	
	fi

	else
		wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -o /tmp/emerging-drop.suricata.rules

fi

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
				echo "netsh advfirewall firewall add rule name="BLOCK IP ADDRESS - ${eachIP}" dir=in action=block remoteip=${eachIP}"

			done
		;;
		h) echo "Usage: $(basename $0) [-i/c/m/n/w/h]"
		;;
		p)
		;;
		*) echo "Invalid value"
		;;
	

	esac

# Create a firewall ruleset
#for eachIP in $(cat badIPs.txt)
#do
#	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

#done

