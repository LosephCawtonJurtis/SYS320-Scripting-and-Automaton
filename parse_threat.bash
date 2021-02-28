#!/bin/bash
# Storyline: Extract IPs from emerging threats.net and create a firewall ruleset

# Regex to extract the networks
#5.         134.         128.   0/    19

#wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -o /tmp/emerging-drop.suricata.rules

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

# Create a firewall ruleset
for eachIP in $(cat badIPs.txt)
do
	echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables

done

