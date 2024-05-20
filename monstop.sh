#!/bin/bash

# Function to stop monitor mode on a given interface
stop_monitor_interface() {
  local interface="$1"
  ifconfig "wlan0mon" down && iw dev "wlan0mon" del
  if [ "$interface" = "wlan0" ]; then
    reload_brcm
  fi
  ifconfig "$interface" up
}

# Function to reload brcm module
reload_brcm() {
  if ! modprobe -r brcmfmac; then
    return 1
  fi
  sleep 1
  if ! modprobe brcmfmac; then
    return 1
  fi
  sleep 2
  iw dev wlan0 set power_save off
  return 0
}

# Check if argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <interface>"
  exit 1
fi

# Stop monitor mode
stop_monitor_interface "$1"
