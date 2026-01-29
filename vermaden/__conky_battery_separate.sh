#! /bin/sh

# Copyright (c) 2018 Slawomir Wojciech Wojtczak (vermaden)
# All rights reserved.
#
# THIS SOFTWARE USES FREEBSD LICENSE (ALSO KNOWN AS 2-CLAUSE BSD LICENSE)
# https://www.freebsd.org/copyright/freebsd-license.html
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS 'AS IS' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ------------------------------
# conky AND dzen2 BATTERY STATUS
# ------------------------------
# vermaden [AT] interia [DOT] pl
# https://vermaden.wordpress.com

# modified by ant (alinxviso) to be usable on linux systems
# taken from https://github.com/vermaden/scripts
# hosted at https://github.com/alinxviso/scripts

# SETTINGS
COLOR_WHITE=#ffffff
COLOR_ORANGE=#ffaa00
COLOR_RED=#dd2200

__color_time() { # 1=TIME
  local TIME=${1}
  if [ ${TIME} -ge 90 ]
  then
    COLOR_TIME=${COLOR_WHITE}
  elif [ ${TIME} -lt 90 -a ${TIME} -ge 30 ]
  then
    COLOR_TIME=${COLOR_ORANGE}
  elif  [ ${TIME} -lt 30 ]
  then
    COLOR_TIME=${COLOR_RED}
  fi
}

__color_life() { # 1=LIFE
  local LIFE=${1}
  if [ ${LIFE} -ge 50 ]
  then
    COLOR_LIFE=${COLOR_WHITE}
  elif [ ${LIFE} -lt 50 -a ${LIFE} -ge 25 ]
  then
    COLOR_LIFE=${COLOR_ORANGE}
  elif  [ ${LIFE} -lt 25 ]
  then
    COLOR_LIFE=${COLOR_RED}
  fi
}

__usage() {
  echo "usage: ${0##*/} TYPE"
  echo
  echo "type: dzen2 | conky"
  echo
  exit 1
}

# TYPE
case ${1} in
  (conky|dzen2) :       ;;
  (*)           __usage ;;
esac

BATS=$(command ls --color=never -l /sys/class/power_supply/ | grep "BAT" | rev | cut -d '/' -f1 | rev )
case $( acpi | grep -o "Charging" ) in
  (Charging)
    LIFE=$( acpi | awk '/Charging/{print int($4)}' )
    __color_life ${LIFE}
    case ${BATS} in
      ("BAT0")
        case ${1} in
          (conky) echo "AC/\${color ${COLOR_LIFE}}${LIFE}%\${color}" ;;
          (dzen2) echo "AC/^fg(${COLOR_LIFE})${LIFE}%" ;;
        esac
        ;;
      (*)
        LIFE=$( acpi | awk '/Discharging/{print int($4)}' )
        BAT0STATE=$( acpi | grep "Battery 0" | grep -eo "Not charging" -oe "Discharging" -oe "Charging")
        BAT0DETECTED=$( acpi | grep -o "Battery 0" || echo "gone" )
	if [ "${BAT0DETECTED}" = "gone" ]
	then
		BAT0="-"
	else
		BAT0=$( acpi | awk '/^Battery 0/{print int($4)}' )
        fi
        BAT1STATE=$( acpi | grep "Battery 1" | grep -eo "Not charging" -oe "Discharging" -oe "Charging")
        BAT1DETECTED=$( acpi | grep -o "Battery 1" || echo "gone" )
	if [ "${BAT1DETECTED}" = "gone" ]
        then
		BAT1="-"
        else
		BAT1=$( acpi | awk '/^Battery 1/{print int($4)}' )
        fi
        case ${1} in
          (conky) echo "AC/${BAT0}/${BAT1}" ;;
          (dzen2) echo "AC/${BAT0}/${BAT1}" ;;
        esac
        ;;
      (*)
        :
        ;;
    esac
    ;;
  (*)
	TIME=$( acpi | awk '/remaining/{print $5}' ) 
	HOUR=$(echo "$TIME" | cut -b 1,2)
	MINS=$(echo "$TIME" | cut -b 4,5)
	TIME=$(( ${MINS} + ( ${HOUR} * 60 )))

# old format assumes one large minute sum, keeping just in case
#    if [ "${TIME}" != "-1" ]
#    then
#      HOUR=$(( ${TIME} / 60 ))
#      MINS=$(( ${TIME} % 60 ))
#      [ ${MINS} -lt 10 ] && MINS="0${MINS}"
#    else
#      # WE HAVE TO ASSUME SOMETHING SO LETS ASSUME 2:22
#      TIME=0
#      HOUR=0
#      MINS=0
#    fi

    __color_time ${TIME}
    __color_life ${LIFE}
    case ${BATS} in
      (1)
        case ${1} in
          (conky) echo "\${color ${COLOR_TIME}}${HOUR}:${MINS}\${color}/${LIFE}%" ;;
          (dzen2) echo "^fg(${COLOR_TIME})${HOUR}:${MINS}^fg()/${LIFE}%"          ;;
        esac
        ;;-oe "Discharging" -oe "Charging"
      (2)
        BAT0STATE=$( acpi | grep "Battery 0" | grep -eo "Not charging" -oe "Discharging" -oe "Charging")
        BAT0DETECTED=$( acpi | grep -o "Battery 0" || echo "gone" )
        if [ "${BAT0DETECTED}" != "gone" ]
        then
		case ${BAT0STATE} in
			("Not charging")
				BAT0=$( acpi | awk '/^Battery 0/{print int($5)}' );;
			(*)
				BAT0=$( acpi | awk '/^Battery 0/{print int($4)}' );;
        	esac
        else
          BAT0="-"
        fi
        BAT1STATE=$( acpi | grep "Battery 1" | grep -oe "Not charging" -oe "Discharging" -oe "Charging" )
        BAT1DETECTED=$( acpi | grep -o "Battery 1" || echo "gone" )
        if [ "${BAT1DETECTED}" != "gone" ]
        then
		case ${BAT1STATE} in
			("Not charging")
				BAT1=$( acpi | awk '/^Battery 1/{print int($5)}' );;
			(*)
				BAT1=$( acpi | awk '/^Battery 1/{print int($4)}' );;
        	esac
	else
          BAT1="-"
        fi
        case ${1} in
          (conky) echo "\${color ${COLOR_TIME}}${HOUR}:${MINS}\${color}/${BAT0}/${BAT1}" ;;
          (dzen2) echo "^fg(${COLOR_TIME})${HOUR}:${MINS}^fg()/${BAT0}/${BAT1}"          ;;
        esac
        ;;
    esac
    ;;
esac
