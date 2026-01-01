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


case $( acpi | grep "Charging" ) in
  (Charging) # will debug later
        LIFE=$(acpi | awk '/Charging/{print ($4)}' ) 
        __color_life ${LIFE}
    case ${1} in
      (conky) echo "AC/\${color ${COLOR_LIFE}}${LIFE}%\${color}" ;;
      (dzen2) echo "AC/^fg(${COLOR_LIFE})${LIFE}%" ;;
    esac
    ;;


  (*) # if it's found that it's not charging
      LIFE=$(acpi | awk '/Discharging/{print ($4)}' | awk '{print int($1)}')
      TIME=$(acpi | awk '/Discharging/{print ($5)}')
      HOUR=$(echo "$TIME" | cut -b 1,2)
      MINS=$(echo "$TIME" | cut -b 4,5)
      TIME=$(( ${MINS} + ( ${HOUR} * 60 )))
#      echo $TIME $HOUR $MINS $LIFE
#      [ ${MINS} -lt 10 ] && MINS="0${MINS}" # not needed because acpi already adds zeros
      
# vvv keeping in case i come across some error vvv
# WE HAVE TO ASSUME SOMETHING SO LETS ASSUME 2:22
#      TIME=142
#      HOUR=2
#      MINS=22
    __color_time ${TIME}
    __color_life ${LIFE}
    case ${1} in
      (conky) echo "\${color ${COLOR_TIME}}${HOUR}:${MINS}\${color}/${LIFE}%" ;;
      (dzen2) echo "^fg(${COLOR_TIME})${HOUR}:${MINS}^fg()/${LIFE}%"          ;;
    esac
    ;;
esac
