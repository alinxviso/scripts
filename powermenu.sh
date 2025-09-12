#!/usr/bin/ksh
function areyousure {
	options="no\nyes"
	yesno=$(echo -e "$options" | dmenu -l 6 -c -p 'Are you sure?')
	if [[ $yesno = "yes" ]]; then
		$yes
	elif [[ $yesno = "no" ]]; then
		exit
	fi
}




if [ "$XDG_SESSION_TYPE" = "x11" ] || [ "$SESSION_TYPE" = "X11" ] ;
then
function powermenu {
	options="cancel\nlock\nsleep\nshutdown\nrestart\nexit dwm\nexit openbox"
	selected=$(echo -e "$options" | dmenu -l 6 -c)
	if [[ $selected = "shutdown" ]]; then
#		yes="doas openrc-shutdown -p now"
		yes="loginctl poweroff"
		areyousure
	elif [[ $selected = "restart" ]]; then
#		yes="doas openrc-shutdown -r now"
		yes="loginctl reboot"
		areyousure
	elif [[ $selected = "sleep" ]]; then
#		loginctl lock-session && sleep 1;doas s2ram
		loginctl suspend
	elif [[ $selected = "lock" ]]; then
		loginctl lock-session
	elif [[ $selected = "cancel" ]]; then
		return
	elif [[ $selected = "exit dwm" ]]; then
		pkill dwm && pkill xinit
	elif [[ $selected = "exit openbox" ]]; then
		openbox --exit
	fi
}
powermenu





elif [ "$XDG_SESSION_TYPE" = "wayland" ] || [ "$SESSION_TYPE" = "Wayland" ] ;
then
function powermenu {
	options="cancel\nlock\nsleep\nshutdown\nrestart\nexit sway"
	selected=$(echo -e "$options" | dmenu -l 6 -c)
	if [[ $selected = "shutdown" ]]; then
#		yes="doas openrc-shutdown -p now"
		yes="loginctl poweroff"
		areyousure
	elif [[ $selected = "restart" ]]; then
#		yes="doas openrc-shutdown -r now"
		yes="loginctl reboot"
		areyousure
	elif [[ $selected = "sleep" ]]; then
		swaylock & sleep 1;doas s2ram
	elif [[ $selected = "lock" ]]; then
		swaylock
	elif [[ $selected = "cancel" ]]; then
		return
	elif [[ $selected = "exit sway" ]]; then
		swaymsg kill
	fi
}
powermenu


fi
