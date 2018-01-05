#!/bin/bash
# Das Programm stellt Files aus den Ordnern  "Anzeigen" und "Anzeigenmp4" dar
# Aufruf mit dem Parameter "endlos" stellt in eine Endlosschleife alles dar
# Pfad in welchem sich alle Skripte und Unterverzeichnisse des usbviewers befinden (evtl. anzupassen)
pfad="/home/pi/rkups/"
# Parameter fürs Datstellen (zeit in sec für eine Bild) auslesen
zeile=$(grep "KonfigParameter" /home/pi/rkups/usbviewconfig.txt)
echo $zeile
zeit=${zeile:0:3}
zeit=$((zeit)) # damit wird aus dem String ein integer
echo Darstellzeit= $zeit
#
eingabe=$1
repeat=1
#echo Eingabparameter in darstellen.sh war $eingabe
while [ $repeat -eq 1 ]
do
# 1. Bilddateien
  echo 1 > /home/pi/rkups/viewerlaeuft.txt # viewerlaeuft.txt wird auf true gestellt
  anzfjpg=$(find $pfad"Anzeigen" -type f | wc -l)  # das ist die Anzahl der Bilddateien
  #echo anzfjpg= $anzfjpg

  if [ $anzfjpg -gt 0 ];then
    sudo fbi -a -T 1 -t $zeit -1 --once -v --noverbose $pfad"Anzeigen/"* >/dev/null 2>&1
    # nun wird gewartet, bis alles angezeigt ist
    x=1111
    y=$(pidof fbi)
    #echo x vor der schleife $x
    #echo y vor der schleife $y
    while [[ `echo "$x" | grep -E ^[[:digit:]]+$` ]] && [ $x -gt 0 ]
    # while [[ 'echo "$x"| grep [[:digit:]]' ]] && [ $x > 0 ]    # warten bis fbi fertig ist (also die PID von fbi keine Zahl>0 mehr ist)
     do 
        x=$(pidof fbi)
        #echo x,y in schleife = $x , $y
     done
  fi
  if [[ `echo "$y" | grep -E ^[[:digit:]]+$` ]] # Killt den fbi Prozess, aber nur wenn es einen gab (also auf y eine Zahl steht)
  then
    sudo kill $y
    #echo fbi Prozess $y wurde erfolgreich gekillt
  fi
# 2. Videos
  anzfmp=$(find $pfad"Anzeigenmp4" -type f | wc -l)  # das ist die Anzahl der mp4s
  #echo anzfmp= $anzfmp

  if [ $anzfmp -gt 0 ];then
    #Anzeigen der mp4 Videos
    files=$pfad"Anzeigenmp4/"*
    #echo files=$files
    for filename in $files  #alle mp4s einzeln viewen
    do
    #echo Video spielen:   $filename
    # Ein schwarzes Hintergrundbild auf die Konsole legen und dann die Videos abspielen
    sudo /usr/bin/fbi -a -t 1 --once --noverbose -T 1 /home/pi/rkups/blackout.jpg
    omxplayer -b $filename
    done
  fi
# prüfen, ob eine Enlosschleife gewollt ist
  if [ "$eingabe" == "endlos" ]
  then
    repeat=1
  else
    repeat=0
  fi
#echo In der Schleife repeat= $repeat
done
echo 0 > /home/pi/rkups/viewerlaeuft.txt # viewerlaeuft.txt wird auf false gestellt

