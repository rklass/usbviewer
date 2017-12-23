#!/bin/bash
# Dieses Script schaelt den angeschlossenen HDMI Monitor an und startet die Anzeige
# Es wird in die Crontab eingebaut und zu bestimmten Uhrzeiten gestartet
# crontab Beispieleintrag: 
# Bildschirm Mo-Fr um 6:20 Uhr einschalten und usbviewer Prozesse starten
# 20 6 * * 1-5 /bin/bash /home/pi/rkups/start.sh >/dev/null 2>&1

/usr/bin/vcgencmd display_power 1
clear
/home/pi/rkups/startanzeigen.sh
exit 0
