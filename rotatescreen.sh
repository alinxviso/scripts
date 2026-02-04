#!/bin/sh

if [ -z "$1" ];then
	echo "USAGE: $(basename $0) <DISPLAY>
	This script rotates your screen, <DISPLAY>, clockwise according to its current orientation
	To figure out what <DISPLAY> should be, run 'xrandr --query' to see the list of active displays
	and pick the one you want to rotate."
	exit
fi


if [ -e /usr/bin/xrandr ];then
__DISPLAY=$1
__MODE=$(xrandr --query | awk -F "${__DISPLAY}" '{print $2}' | cut -d ' ' -f4 | sed -z 's/\n//g')
echo "${#__MODE}"
echo "${__MODE}"
	if [ "${#__MODE}" -gt 8 ]; then
		echo "Display ${__DISPLAY} does not exist! Ensure that you typed it in correctly or that it appears in 'xrandr --query'"
	else	
		case $__MODE in
			"(normal")
		       		echo right	
				xrandr --output "${__DISPLAY}" --rotate right;;
			"right")
				echo inverted
				xrandr --output "${__DISPLAY}" --rotate inverted;;
			"inverted")
				echo left
				xrandr --output "${__DISPLAY}" --rotate left;;
			"left")
				echo normal
				xrandr --output "${__DISPLAY}" --rotate normal;;
			*)
				echo "mode ${__MODE} is incorrect, if this seems to be a script issue please submit a bug report"
		esac
	fi

else
	echo "xrandr was not found at '/usr/bin/xrandr' please ensure it is installed and is in your \$PATH"
fi
