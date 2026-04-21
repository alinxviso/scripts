#!/usr/bin/sh
if [ "$(nmcli radio wifi)" = "enabled" ]; then
	nmcli radio wifi off && notify-send -h string:x-canonical-private-synchronous:wifi-radio "WiFi radio disabled" -t 2000 -e
else
	nmcli radio wifi on && notify-send -h string:x-canonical-private-synchronous:wifi-radio "WiFi radio enabled" -t 2000 -e
fi
