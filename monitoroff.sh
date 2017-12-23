#!/bin/bash
# Dieses Script schaelt den angeschlossenen HDMI Monitor ab und beendet die Skripte
# Es wird in die Crontab eingebaut und zu bestimmten Uhrzeiten gestartet
# crontab Beispieleintrag: 
# Bildschirm Mo-Fr um 18:30 ausschalten und alle usbviewer Prozesse killen
# 30 18 * * 1-5 /bin/bash /home/pi/rkups/stop.sh > /dev/tty1 2>&1

# Prozesse abschiessen
pid=$(ps -aux | grep '/bin/bash /home/pi/rkups/startanzeigen.sh' | awk '{print $2}')
kill -9 $pid
pids=$(ps -aux | grep 'bash /home/pi/rkups/darstellen.sh' | awk '{print $2}')
kill -9 $pids
clear
sleep 2
/usr/games/cowsay -f tux Bildschirm wird in 1 Minute ausgeschaltet...! 
sleep 60
vcgencmd display_power 0
exit 0
