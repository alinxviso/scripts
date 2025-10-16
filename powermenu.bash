#!/usr/bin/bash
# See comments at bottom for configuration


if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
	runner="mew -i -l 7"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
	runner="dmenu -l 7 -c" 
fi

if [ -z "$currentwm" ];then
	currentwm="$XDG_CURRENT_DESKTOP"
fi

lockcmd="loginctl lock-session"
if [ -e /sys/power/resume ];then
sleepcmd="systemctl suspend-then-hibernate"
hibernatecmd="systemctl hibernate"
else
sleepcmd="systemctl suspend"
fi
rebootcmd="systemctl reboot"
poweroffcmd="systemctl poweroff"
no="exit"
source $HOME/.scripts/powermenu-sessions.bash
currentwm=${currentwm,,}

function areyousure {
	options="no\nyes"
	yesno=$(echo -e "$options" | $runner -p 'Are you sure?')
	if [[ $yesno = "yes" ]]; then $yes
	elif [[ $yesno = "no" ]]; then $no
	fi
}

function powermenu {
	if [[ $hibernate = "true" ]]; then
		options="cancel\nlock\nsleep\nhibernate\nrestart\nshutdown\nexit $currentwm"
	else
		options="cancel\nlock\nsleep\nrestart\nrshutdown\nexit $currentwm"
	fi
	selected=$(echo -e "$options" | $runner)
	if [[ $selected = "cancel" ]]; then
		return

	elif [[ $selected = "lock" ]]; then
		$lockcmd

	elif [[ $selected = "sleep" ]]; then
		$sleepcmd

	elif [[ $selected = "hibernate" ]]; then
		$hibernatecmd

	elif [[ $selected = "restart" ]]; then
		yes="$rebootcmd"
		areyousure

	elif [[ $selected = "shutdown" ]]; then
		yes="$poweroffcmd"
		areyousure

	elif [[ $selected = "exit $currentwm" ]]; then
		$exitcurrentwm

	fi
}
powermenu && exit

notify-send "did nothing show up?" "make sure XDG_SESSION_TYPE is set to either 'x11' or 'wayland', or that dmenu has the center patch applied. see script for more details" || echo "did nothing show up? make sure XDG_SESSION_TYPE is set to either 'x11' or 'wayland', or that dmenu has the center patch applied. see script for more details"


#################################################################################################################################################################################################################################################################################
#                                                                                                                                 CONFIGURATION                                                                                                                                 #
#################################################################################################################################################################################################################################################################################

# Every variable can be changed in the "powermenu-settings.bash" file, all well as the session commands, which lets you set defaults or create new sessions.




#################################################################################################################################################################################################################################################################################
#                                                                                                                                   SESSIONS                                                                                                                                   #
#################################################################################################################################################################################################################################################################################

# Sessions let you change every command or variable for a specific session, or add a new one.   If you have a WM or DE that isn't in the defaults, you can easily add your own or modify an existing one
#

