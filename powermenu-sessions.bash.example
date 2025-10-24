if [ -e /sys/power/resume ];then
	hibernate="true"
	echo hibernate is possible
fi
lockcmd="loginctl lock-session"
sleepcmd="systemctl suspend"
hibernatecmd="systemctl hibernate"
rebootcmd="systemctl reboot"
poweroffcmd="systemctl poweroff"
no="exit"



### Sessions
# Most are untested so please submit a pull or bug report if one doesn't work

if [[ $currentwm = "dwm" ]];then
	exitcurrentwm="pkill dwm && pkill xinit"

elif [[ $currentwm = "bspwm" ]];then
	exitcurrentwm="bspc quit"

elif [[ $currentwm = "qtile" ]];then
	exitcurrentwm="qtile cmd-obj -o cmd -f shutdown"

elif [[ $currentwm = "openbox" ]];then
	exitcurrentwm="openbox --exit"

elif [[ $currentwm = "hyprland" ]]; then
	exitcurrentwm="hyprctl dispatch exit"

elif [[ $currentwm = "i3" ]] || [[ $currentwm = "i3wm" ]]; then
	exitcurrentwm="i3-msg exit"

elif [[ $currentwm = "sway" ]] || [[ $currentwm = "swaywm" ]]; then
	exitcurrentwm="swaymsg exit"

elif [[ $currentwm = "kill literally everything dude" ]];then
	exitcurrentwm="loginctl kill-session $XDG_SESSION_ID"

fi
