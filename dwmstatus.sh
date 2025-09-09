#!/usr/bin/ksh

# Checks if the device is a laptop
if [ -e /sys/class/power_supply/AC ]; then
	while true
	do
	echo "$(sensors thinkpad-isa-0000 | awk '/CPU/{print ($2)} ')°C MEM:$(free --mega | awk '/^Mem:/{print int($3)}')mb/$(free --mega | awk '/^Mem:/{print int($2)}')mb" > /run/user/"$(id -u)"/dwmstatus
	sleep 2
	done &

	while true
	do
	xsetroot -name "$(cat /run/user/$(id -u)/dwmstatus) VOL:$(pamixer --get-volume-human) $(date +'%Y/%m/%d/%a/%H:%M:%S')"
	sleep 0.1
	done &
else	
# If it's not, it's a gigabyte pc
	while true
	do
	echo "$(sensors gigabyte_wmi-virtual-0 | awk '/temp4/{print ($2)} ')°C MEM:$(free --mega | awk '/^Mem:/{print int($3)}')mb/$(free --mega | awk '/^Mem:/{print int($2)}')mb" > /run/user/"$(id -u)"/dwmstatus
	sleep 2
	done &
	
	while true
	do
	xsetroot -name "$(cat /run/user/$(id -u)/dwmstatus) VOL:$(pamixer --get-volume-human) $(date +'%Y/%m/%d/%a/%H:%M:%S')"
	sleep 0.1
	done &
fi
