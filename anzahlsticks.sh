#!/bin/bash
sudo blkid > ~/rkups/ausgabe.txt   #schreibt den namen der eingesteckten Medien auf ausgabe.txt
anzahl=$(egrep -rc -e "dev/sd" ~/rkups/ausgabe.txt)
#anzahl2=$(egrep -rc -e "sdb" ~/rkups/ausgabe.txt)
#anzahl=$(($anzahl1 + $anzahl2))
echo $anzahl
# mit x=$(bash /home/pi/rkups/anzahlsticks.sh ) bekommt x den Wert der Anzahl Sticks
