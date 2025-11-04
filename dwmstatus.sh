#!/bin/sh

# As to not type 'id -u' a million times, only use if /bin/sh is not a symlink to bash
# EUID=$(id -u)

# Checks if the device is a laptop
if [ -e /sys/class/power_supply/AC ]; then
	while true
	do
#	echo "$(sensors coretemp-isa-0000 | awk '/P/{print int($4)} ')°C MEM:$(free --mega | awk '/^Mem:/{print int($3)}')mb/$(free --mega | awk '/^Mem:/{print int($2)}')mb" $(~/.scripts/statusbar/battery) > /run/user/${EUID}/dwmstatus
	echo "$(~/.scripts/statusbar/sys) | $(~/.scripts/statusbar/battery) |" > /run/user/${EUID}/dwmstatus
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
	echo "$(sensors coretemp-isa-0000 | awk '/P/{print int($4)} ')°C MEM:$(free --mega | awk '/^Mem:/{print int($3)}')mb/$(free --mega | awk '/^Mem:/{print int($2)}')mb" > /run/user/${EUID}/dwmstatus
	sleep 2
	done &
	
	while true
	do
	xsetroot -name "$(cat /run/user/${EUID}/dwmstatus) VOL:$(pamixer --get-volume-human) $(date +"%Y/%m/%d/%a/%I:%M:%S%P")"
	sleep 0.1
	done &
fi
