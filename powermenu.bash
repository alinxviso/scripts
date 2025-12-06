#!/usr/bin/env bash
# See comments at bottom for configuration

## if there's no session file detected, prompt for creation
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

## Default commands
lockcmd="loginctl lock-session"
sleepcmd="systemctl suspend"
rebootcmd="systemctl reboot"
poweroffcmd="systemctl poweroff"
no="exit"
if [ -e /sys/power/resume ];then # check if the system is able to hibernate
	hibernate="true"
	echo hibernate is possible
	sleepcmd="systemctl suspend-then-hibernate"
	hibernatecmd="systemctl hibernate"
	echo $hibernatecmd
fi

# Picks what file to use for settings
if [ -e "$HOME/.scripts/powermenu-settings.bash" ]; then
	source "$HOME/.scripts/powermenu-settings.bash"
else
	source "$HOME/.scripts/powermenu-settings.bash.default"
fi
currentwm=${currentwm,,} ## makes the session all lowercase for uniformity, bashism

## prompts for verification for stuff
function areyousure {
	options="no\nyes"
	yesno=$(echo -e "$options" | $runner -p 'Are you sure?')
	if [[ $yesno = "yes" ]]; then $yes
	elif [[ $yesno = "no" ]]; then $no
	fi
}

## The actual menu!!
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

# Every variable can be changed in the "powermenu-settings.bash" file, which lets you set
# defaults or create new sessions. If it's not found it will use the .default file.




#########################################################################################
#                                      SESSIONS                                         #
#########################################################################################

# Sessions are the settings that are used for the detected wm using "$currentwm" which is
# set manually, by $XDG_SESSION_DESKTOP, or by $XDG_CURRENT_DESKTOP, in that order.
# They set what commands are run for each option, and the name that shows up in the menu.
#
# More explanation is given within the settings file
