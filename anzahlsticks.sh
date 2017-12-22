#!/bin/bash
# Pfad in welchem sich alle Skripte und Unterverzeichnisse des usbviewers befinden (evtl. anzupassen)
pfad="/home/pi/rkups/"
sudo blkid > $pfad"ausgabe.txt"   #schreibt den namen der eingesteckten Medien auf ausgabe.txt
anzahl=$(egrep -rc -e "dev/sd" $pfad"ausgabe.txt")
echo $anzahl
# mit x=$(bash /home/pi/rkups/anzahlsticks.sh ) bekommt x den Wert der Anzahl Sticks
