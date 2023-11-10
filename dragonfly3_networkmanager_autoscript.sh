#!/bin/bash

USERNAME=""
PASSWORD=""
INTERFACE=$(route | grep "^default" | awk '{print $8}')

echo "Using interface $INTERFACE"
read -p "Enter Drexel Username " USERNAME
read -s -p "Enter Drexel Password " PASSWORD 
echo ""

nmcli connect add \
	ifname $INTERFACE \
	con-name dragonfly3 \
	save yes \
	type wifi \
	ssid "dragonfly3" \
	mode infrastructure \
	-- \
	+802-1x.identity $USERNAME \
	+802-1x.password $PASSWORD \
	+802-1x.eap peap \
	+802-1x.phase2-auth mschapv2 \
	+wifi-sec.auth-alg open \
	+wifi-sec.key-mgmt wpa-eap \
	+ipv4.method auto \
	+ipv6.method auto \
