#!/usr/bin/ksh
if [ -z "$N" ]; then
N=10000
fi

time(for i in $(eval echo "{1..$N}"); do
$1 >/dev/null
done)
