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


if [ "$currentwm" = "hyprland" ]; then
	exitcurrentwm="hyprctl dispatch exit"
fi
