#!/usr/bin/sh
wmctrl -d | awk '/\*/{print $NF}' | head -c 1 | tee ~/.scripts/desktopchange.log; echo
