#!/bin/bash
# Storyline: script to create a wireguard server

# create a private key
p="$(wg genkey)"


# create a public key
pub="$(echo ${p} | wg pubkey)"

# set the addresses
address="10.254.132.0/24,172.16.28.0/24"

# set server IP addresses
ServerAddress="10.254.132.1/24,172.16.28.1/24"

# set the listen port
lport="4282"

peerInfo="# ${address} 198.199.97.163:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"

echo "${peerInfo}
[interface]
Address = ${ServerAddress}
#PostUp = /etc/weireguard/wg-up.bash
#PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lport}
PrivateKey = ${p}
" > wg0.conf
