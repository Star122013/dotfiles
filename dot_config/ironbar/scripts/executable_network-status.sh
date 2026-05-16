#!/usr/bin/env sh

wifi_line=$(nmcli -t -f DEVICE,TYPE,STATE,SIGNAL device status 2>/dev/null | awk -F: '$2=="wifi" && $3=="connected" { print $1":"$4; exit }')
if [ -n "$wifi_line" ]; then
  signal=${wifi_line##*:}
  printf '  %s%%\n' "$signal"
  exit 0
fi

eth_dev=$(nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null | awk -F: '$2=="ethernet" && $3=="connected" { print $1; exit }')
if [ -n "$eth_dev" ]; then
  printf '󰈀  %s\n' "$eth_dev"
  exit 0
fi

printf '󰖪\n'
