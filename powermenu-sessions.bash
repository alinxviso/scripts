if [ -e /sys/power/resume ];then
	echo hibernate is possible do the thing
fi

if [ "$currentwm" = "hyprland" ]; then
	exitcurrentwm="hyprctl dispatch exit"
fi
