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
# DZEN2 UPDATE
# ------------------------------
# vermaden [AT] interia [DOT] pl
# https://vermaden.wordpress.com

# SETTINGS
CLA='^fg(#aaaaaa)'
CVA='^fg(#eeeeee)'
CDE='^fg(#dd0000)'

# GATHER DATA
DATE=$(    date +%Y/%m/%d/%a/%H:%M )
FREQ=$(    awk '/MHz/{ temp+=$4; n++ } END{ printf("%f\n", temp/n) }' /proc/cpuinfo | awk '{ sub(".[^.]*$", ""); print }')
TEMP=$(    sensors thinkpad-isa-0000 | awk '/CPU/{print int($2)}')
LOAD=$(    cat /proc/loadavg | awk '{print ($2)}')
## For some reason the MEM variable shows free memory instead of used, so i'll keep that
## if you want mem used just change $4 to $3 and it should work
MEM=$(     free --mega | awk '/Mem/{print int($4)/1024}' | cut -c 1-4 )

#IF_IP=$(   ~/scripts/__conky_if_ip.sh )
IF_IP=$(   echo 127.0.0.1 )
IF_GW=$(   ~/.scripts/vermaden/__conky_if_gw.sh )
IF_DNS=$(  ~/.scripts/vermaden/__conky_if_dns.sh )
IF_PING=$( ~/.scripts/vermaden/__conky_if_ping.sh dzen2 )
VOL=$(     pamixer --get-volume )
FS=$(      zfs list -H -d 0 -o name,avail | awk '{printf("%s/%s ",$1,$2)}' )
BAT=$(     ~/.scripts/vermaden/__conky_battery.sh dzen2 )
PS=$(      ps ax -o %cpu,rss,comm | sed 1d | grep -v 'idle$' | sort -r -n | head -3 | awk '{printf("%s/%d%%/%.1fGB ",$3,$1,$2/1024/1024)}' )

# PRESENT DATA
echo -n        " ${CLA}date: ${CVA}${DATE} "
echo -n "${CDE}| ${CLA}sys: ${CVA}${FREQ}MHz/${TEMP}/${LOAD}/${MEM}GB "
echo -n "${CDE}| ${CLA}ip: ${CVA}${IF_IP}"            # NO SPACE AT THE END
echo -n "${CDE}| ${CLA}gw: ${CVA}${IF_GW} "
echo -n "${CDE}| ${CLA}dns: ${CVA}${IF_DNS} "
echo -n "${CDE}| ${CLA}ping: ${CVA}${IF_PING} "
#echo -n "${CDE}| ${CLA}vol/pcm: ${CVA}${VOL}/${PCM} "
echo -n "${CDE}| ${CLA}vol: ${CVA}${VOL}/100 "
echo -n "${CDE}| ${CLA}fs: ${CVA}${FS}"               # NO SPACE AT THE END
echo -n "${CDE}| ${CLA}bat: ${CVA}${BAT} "
echo -n "${CDE}| ${CLA}top: ${CVA}${PS}"              # NO SPACE AT THE END
echo

echo '1' >> ~/.scripts/vermaden/stats/$( basename ${0} )
