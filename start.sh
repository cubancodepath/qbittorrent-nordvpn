#!/bin/bash

# Start NordVPN service
/etc/init.d/nordvpn start
sleep 5

# Configure NordVPN to allow local traffic
nordvpn set technology nordlynx
nordvpn whitelist add port 8080
nordvpn whitelist add subnet 172.16.0.0/12
nordvpn whitelist add subnet 192.168.0.0/16
nordvpn whitelist add subnet 10.0.0.0/8

# Login to NordVPN with token
until nordvpn login --token "${NORDVPN_TOKEN}"; do
    echo "Waiting for valid NordVPN token..."
    sleep 5
done

# Connect to NordVPN with specified country
if [ -n "${NORDVPN_COUNTRY}" ]; then
    echo "Connecting to NordVPN in ${NORDVPN_COUNTRY}"
    nordvpn connect ${NORDVPN_COUNTRY}
else
    echo "Connecting to NordVPN (default)"
    nordvpn connect
fi

# Wait until VPN connection is established
until nordvpn status | grep -q "Status: Connected"; do
    echo "Waiting for VPN connection..."
    nordvpn status
    sleep 5
done

echo "VPN connected successfully"

# Start qBittorrent directly
exec qbittorrent-nox --webui-port=8080 --profile=/ --save-path=/downloads