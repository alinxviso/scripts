#!/usr/bin/sh
wmctrl -d | awk '/\*/{print $NF}' | head -c 1 | tee /run/user/`id -u`/desktopchange.log; echo
