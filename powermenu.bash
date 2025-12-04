#!/usr/bin/env bash
# See comments at bottom for configuration


function nosession {
	case "$XDG_SESSION_TYPE" in
		[Ww]"ayland" )	export runner="bemenu -i -c -l 7 -W.1 -p /" ;;
		[Xx]"11" )	export runner="dmenu -l 7 -c" ;;
	esac
	options="no\nyes"
	yesno=$(echo -e "$options" | $runner -p 'session file was not found, copy example?')
	if [[ $yesno = "yes" ]]; then 
		cp "$HOME/.scripts/powermenu-sessions.bash.example" "$HOME/.scripts/powermenu-sessions.bash"
		echo copied!
	elif [[ $yesno = "no" ]]; then exit
	fi
}

# Default commands
lockcmd="loginctl lock-session"
sleepcmd="systemctl suspend"
rebootcmd="systemctl reboot"
poweroffcmd="systemctl poweroff"
no="exit"
if [ -e /sys/power/resume ];then
	hibernate="true"
	echo hibernate is possible
	sleepcmd="systemctl suspend-then-hibernate"
	hibernatecmd="systemctl hibernate"
	echo $hibernatecmd
fi
## Keep this line so your session saves!!!
if [ -e "$HOME/.scripts/powermenu-sessions.bash" ]; then
	source "$HOME/.scripts/powermenu-sessions.bash"
else
	nosession
fi
currentwm=${currentwm,,}

function areyousure {
	options="no\nyes"
	yesno=$(echo -e "$options" | $runner -p 'Are you sure?')
	if [[ $yesno = "yes" ]]; then $yes
	elif [[ $yesno = "no" ]]; then $no
	fi
}

function powermenu {
	if [[ -z "$hibernate" ]]; then
		options="cancel\nlock\nsleep\nrestart\nshutdown\nexit $currentwm"
	else
		options="cancel\nlock\nsleep\nhibernate\nrestart\nshutdown\nexit $currentwm"
	fi
	selected=$(echo -e "$options" | $runner)
	case $selected in
		"cancel" )      return;;
		"lock" )        $lockcmd;;
		"sleep" )       $sleepcmd;;
		"hibernate" )   yes="$hibernatecmd" areyousure;;
		"restart" )     yes="$rebootcmd" areyousure;;
		"shutdown" )    yes="$poweroffcmd" areyousure;;
		"exit $currentwm" ) yes="$exitcurrentwm" areyousure ;;
	esac
}
powermenu && exit

notify-send "did nothing show up?" "make sure XDG_SESSION_TYPE is set to either 'x11' or 'wayland', or that dmenu has the center patch applied. see script for more details" || echo "did nothing show up? make sure XDG_SESSION_TYPE is set to either 'x11' or 'wayland', or that dmenu has the center patch applied. see script for more details. By default the script uses bemenu for wayland and dmenu for x11"


#########################################################################################
#                                    CONFIGURATION                                      #
#########################################################################################

# Every variable can be changed in the "powermenu-settings.bash" file, all well as the session commands, which lets you set defaults or create new sessions.
# To use the powermenu, first copy powermenu-sessions.bash.example to powermenu-sessions.bash, then make any changes you want




#########################################################################################
#                                      SESSIONS                                         #
#########################################################################################

# Sessions let you change every command or variable for a specific session, or add a new one.   
# If you have a WM or DE that isn't in the defaults, you can easily add your own or modify an existing one


