#!/bin/bash

# Storyline: Create peer VPN configuration file

if [[ $1 == "" ]]
then
	# What is the peer's name
	echo -n "What is the peer's name? "
	read the_client
else
	the_client="$1"
fi

# Filename variable
pFile="${the_client}-wg0.conf"
	
# Check if the peer file exists
if [[ -f "${pFile}" ]]
then
	# Prompt if we need to overwrite the file
	echo "The file ${pFile} exists."
	echo -n "do you want to overwrite it [y|N]"
	read to_overwrite

	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
	then
		echo "Exit..."
		exit 0
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Creating the wireguard configuration file..."

	# if the admin doesn't specify a y or N then error.
	else
		echo "Invalid value"
		exit 1

	fi
fi

# Create a private key
p="$(wg genkey)"

# Create a public key
clientPub="$(echo ${p} | wg pubkey)"

# Generate a preshared key
pre="$(wg genpsk)"

# 10.254.132.0/24,172.16.28.0/24 198.199.97.163:4282 wqAGfV58dp0/R/JZqgMy+dcBQ3Wq9oeAFxW7Y2E9uFs= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0

# Endpoint
end="$(head -1 wg0.conf  | awk ' { print $3 } ')"

# Server Public Key
pub="$(head -1 wg0.conf  | awk ' { print $4 } ')"

# DNS servers
dns="$(head -1 wg0.conf  | awk ' { print $5 } ')"

# MTU
mtu="$(head -1 wg0.conf  | awk ' { print $6 } ')"

# KeepAlive
keep="$(head -1 wg0.conf  | awk ' { print $7 } ')"

# Listen Port
lport="$(shuf -n1 -i 40000-50000)"

# Check if the IP based on the network:

# Generate the IP address
tempIP="$(grep AllowedIPs wg0.conf | sort -u |tail -1 | cut -d\. -f4 | cut -d\/ -f1)"
ip="$(expr ${tempIP} + 1)"


# Default routes for VPN
routes="$(head -1 wg0.conf  | awk ' { print $8 } ')"

# Create the client configuration file

echo "[Interface]
Address = 10.254.132.${ip}/24
DNS = ${dns}
ListenPort = ${lport}
MTU = ${mtu}
PrivateKey = ${p}

[Peer]
AllowedIPs = ${routes}
PersistentKeepalive = ${keep}
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}	
" > ${pFile}

# Add our peer configuration to the server config
echo "

# ${the_client} begin
[Peer]
PublicKey = ${clientPub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.${ip}/32
# ${the_client} end" | tee -a wg0.conf

