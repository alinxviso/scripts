#!/bin/sh

# to support euid if /bin/sh isn't bash
sh="$(realpath /bin/sh)"
truncsh="${sh##*/}"
if [ "$truncsh"  != "bash" ]; then
	EUID=$(id -u)
fi

## IMPORTANT
# if you have an intel cpu, you will have to have the coretemp module loaded an the sys script must have the coretemp argument
# if you have an amd cpu, you will have to have the k10temp module loaded and the sys script must have the k10temp argument


# Checks if the device is a laptop
if [ -e /sys/class/power_supply/AC ]; then
	while true
	do
#	echo "$(sensors coretemp-isa-0000 | awk '/P/{print int($4)} ')°C MEM:$(free --mega | awk '/^Mem:/{print int($3)}')mb/$(free --mega | awk '/^Mem:/{print int($2)}')mb" $(~/.scripts/statusbar/battery) > /run/user/${EUID}/dwmstatus
	echo "$(~/.scripts/statusbar/sys coretemp) | $(~/.scripts/statusbar/battery) |" > /run/user/${EUID}/dwmstatus
	sleep 2
	done &

	while true
	do
		xsetroot -name "$(cat /run/user/${EUID}/dwmstatus) bright:$(brightnessctl -m | cut -d ',' -f 4) | vol:$(pamixer --get-volume-human) | $(date +"%Y/%m/%d/%a/%I:%M:%S%P")"
	sleep 0.1
	done &
else	
# If it's not, don't show backlight or battery
	while true
	do
#	echo "$(sensors coretemp-isa-0000 | awk '/P/{print int($4)} ')°C MEM:$(free --mega | awk '/^Mem:/{print int($3)}')mb/$(free --mega | awk '/^Mem:/{print int($2)}')mb" > /run/user/${EUID}/dwmstatus
	echo "$(~/.scripts/statusbar/sys k10temp) |" > /run/user/${EUID}/dwmstatus
	sleep 2
	done &
	
	while true
	do
	xsetroot -name "$(cat /run/user/${EUID}/dwmstatus) VOL:$(pamixer --get-volume-human) | $(date +"%Y/%m/%d/%a/%I:%M:%S%P")"
	sleep 0.1
	done &
fi
