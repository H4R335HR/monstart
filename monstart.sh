#!/bin/bash

# Function to start monitor mode on a given interface
start_monitor_interface() {
  local interface="$1"
  rfkill unblock all
  ifconfig "$interface" up
  sleep 3
  iw dev "$interface" set power_save off
  phy_interface=$(iw dev "$1" info | grep wiphy | awk '{print "phy"$2}')
  iw phy "$phy_interface" interface add "wlan0mon" type monitor
  sleep 2
  rfkill unblock all
  ifconfig "$interface" down
  ifconfig "wlan0mon" up
  iw dev "wlan0mon" set power_save off
  systemctl restart pwnagotchi.service
}

# Check if argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <interface>"
  exit 1
fi

# Start monitor mode
start_monitor_interface "$1"
