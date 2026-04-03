#!/usr/bin/bash

export STATUS_FILE="$XDG_RUNTIME_DIR/touchscreen.status"

disable_touchscreen() {
	printf "disabled" > "$STATUS_FILE"
	notify-send "Touchscreen disabled" -h string:x-canonical-private-synchronous:toggle-touchscreen-hypr --expire-time=2000
	hyprctl keyword "\$TOUCH_ENABLED" false
	hyprctl keyword device[elan-touchscreen] ''
}

if [ -e "$STATUS_FILE" ]; then
	enable_touchscreen() {
		printf "enabled" > "$STATUS_FILE"
		notify-send "Touchscreen enabled" -h string:x-canonical-private-synchronous:toggle-touchscreen-hypr --expire-time=2000
		hyprctl keyword "\$TOUCH_ENABLED" true 
		hyprctl keyword device[elan-touchscreen] ''
	}
	if [ "$(cat $STATUS_FILE)" = "disabled" ]; then
		enable_touchscreen
	else
		disable_touchscreen
	fi

else
	disable_touchscreen
fi
