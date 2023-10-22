#!/bin/bash

USERNAME=""
PASSWORD=""
CA_CERT_PATH=""
DRAGONFLY_CERT_URL="https://comodoca.file.force.com/sfc/dist/version/download/?oid=00D1N000002Ljih&ids=0683l00000ENwaHAAT&d=%2Fa%2F3l000000VZ4M%2Fie5Sho19m8SLjTZkH_VL8efOD1qyGFt9h5Ju1ddtbKQ&operationContext=DELIVERY&viewId=05H5c000000jDrXEAU&dpt="
INTERFACE=$(route | grep "^default" | awk '{print $8}')
CONFIG_DIR="$(getent passwd $(whoami) | cut -d: -f6)/.config/dragonfly"

if [[ ! -e $CONFIG_DIR ]]; then
	mkdir $CONFIG_DIR
	echo "Created $CONFIG_DIR in which to store dragonfly3.crt"
fi

curl -o dragonfly3.crt "$DRAGONFLY_CERT_URL"
mv dragonfly3.crt $CONFIG_DIR
echo "Downloaded dragonfly3.crt to $CONFIG_DIR"
CA_CERT_PATH="$CONFIG_DIR/dragonfly3.crt"

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
	+802-1x.ca-cert "$CA_CERT_PATH" \
	+802-1x.identity $USERNAME \
	+802-1x.password $PASSWORD \
	+802-1x.eap peap \
	+802-1x.phase2-auth mschapv2 \
	+wifi-sec.auth-alg open \
	+wifi-sec.key-mgmt wpa-eap \
	+ipv4.method auto \
	+ipv6.method auto \
	+ipv6.addr-gen-mode default
