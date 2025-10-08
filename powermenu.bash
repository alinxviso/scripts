#!/usr/bin/bash
# See comments at bottom for configuration


if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	runner="mew -i -l 6"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
	runner="dmenu -l 6 -c" 
fi

if [ -z "$currentwm" ];then
	currentwm="$XDG_CURRENT_DESKTOP"
fi
currentwm=${currentwm,,}
source $HOME/.scripts/powermenu-sessions.bash

sleepcmd="systemctl suspend"
rebootcmd="systemctl reboot"
poweroffcmd="systemctl poweroff"
lockcmd="loginctl lock-session"
no="exit"

function areyousure {
	options="no\nyes"
	yesno=$(echo -e "$options" | $runner -p 'Are you sure?')
	if [[ $yesno = "yes" ]]; then $yes
	elif [[ $yesno = "no" ]]; then $no
	fi
}

function powermenu {
	options="cancel\nlock\nsleep\nshutdown\nrestart\nexit $currentwm"
	selected=$(echo -e "$options" | $runner)
	if [[ $selected = "shutdown" ]]; then
		yes="$poweroffcmd"
		areyousure
	elif [[ $selected = "restart" ]]; then
		yes="$rebootcmd"
		areyousure
	elif [[ $selected = "sleep" ]]; then
		$sleepcmd

	elif [[ $selected = "lock" ]]; then
		$lockcmd

	elif [[ $selected = "cancel" ]]; then
		return

	elif [[ $selected = "exit $currentwm" ]]; then
		$exitcurrentwm
	fi
}
powermenu && exit

notify-send "did nothing show up?" "make sure XDG_SESSION_TYPE is set to either 'x11' or 'wayland', or that dmenu has the center patch applied. see script for more details" || echo "did nothing show up? make sure XDG_SESSION_TYPE is set to either 'x11' or 'wayland', or that dmenu has the center patch applied. see script for more details"

