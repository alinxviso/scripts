#!/usr/bin/ksh

# i technically made this one from scratch but really i'm just stealing from mkfifo and doing it better

# SETTINGS
DELAY=60
FONT='Ubuntu Mono-10'
FG='#eeeeee'
BG='#222222'
NR="(sh|tail)\ *dzen2-fifo"
ME=$$
DOS='onstart=raise'
#DOS='onstart=lower'
DB1='button1=exec:~/.scripts/vermaden/dzen2-update.sh > /run/user/"$(id -u)"/dzen2-fifo'
DB2='button2=exec:~/.scripts/vermaden/xdotool.sh workmenu'
DB3='button3=exec:~/.scripts/vermaden/xdotool.sh menu'
DB4='button4=exec:~/.scripts/vermaden/xdotool.sh down'
DB5='button5=exec:~/.scripts/vermaden/xdotool.sh up'

# first we kill dzen2, assuming you haven't changed the binary name or smth
killall dzen2
killall dzen2-mkfifo.sh

# then we get rid of any leftovers
rm -f /run/user/"$(id -u)"/dzen2-fifo

# now instead of fifo, just pipe it directly so it updates live
while true
do
	~/.scripts/vermaden/dzen2-update
	sleep 1
done | dzen2 \
	-w 3600
	-fg "${FG}"
	-bg "${BG}"
	-fn "${FONT}"
	-ta l
	-e "${DOS};${DB1};${DB2};${DB3};${DB4};${DB5}" &

# you can change "-ta l" to "-ta c" or "-ta r" for centered and right respectively

rm -f ~/.scripts/vermaden/stats/$( basename ${0} ) 
mkfifo  ~/.scripts/vermaden/stats/$( basename ${0} ) 
echo '1' > ~/.scripts/vermaden/stats/$( basename ${0} ) 
