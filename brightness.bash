#!/usr/bin/bash

##########################################################################################################
# DO NOT USE THIS SCRIPT, IT IS VERY SLOW. INSTEAD USE BRIGHTNESSCTL
##########################################################################################################




source "$HOME"/.scripts/brightnesscommands.bash
#brightnesscmd="qdbus6 org.kde.org_kde_powerdevil /org/kde/Solid/PowerManagement/Actions/BrightnessControl"
#currentbrightnesscmd="$brightnesscmd brightness"
#setbrightnesscmd="$brightnesscmd setBrightness"
#raisebrightnesscmd="$setbrightnesscmd $(qalc -t $($currentbrightnesscmd) + $2)"
#lowerbrightnesscmd="$setbrightnesscmd $(qalc -t $($currentbrightnesscmd) - $2)"

#echo $setbrightnesscmd
#echo $currentbrightnesscmd
#echo $raisebrightnesscmd
#echo $lowerbrightnesscmd

if [ "$1" = "up" ] || [ "$1" = "down" ] || [ "$1" = "set" ];then
	if [[ "$2" =~ ^-?[0-9]+$ ]];then
		if [ "$1" = "up" ];then 
			$raisebrightnesscmd
		elif [ "$1" = "down" ];then
			$lowerbrightnesscmd
		elif [ "$1" = "set" ];then
			$setbrightnesscmd "$2"
		fi
	else
		echo 'second arg is not a valid integer'
	fi
else
	echo "USAGE: $(basename "${0}") [option] [positive integer]"
	echo "This script depends on libqalculate and powerdevil by default, but can be changed by"
	echo "setting \$setbrightnesscmd, \$currentbrightnesscmd, \$raisebrightnesscmd,"
	echo "and \$lowerbrightnesscmd in the settings file located at "
	echo "\$HOME/.scripts/brightnesscommands.bash. Please review how the script functions before"
	echo "changing these variables to ensure compatibility."
	echo -e "\nOPTIONS"
	echo "  up                         raise the brightness by '\$2'"
	echo "  down                       lower the brightness by '\$2'"
	echo "  set                        set the brightness to '\$2'"
fi
